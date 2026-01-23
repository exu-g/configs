#!/usr/bin/env python3

# multithreading
import multiprocessing

# audio format conversions
import ffmpy

# argument parsing
import argparse

# multiprocessing stuff
from multiprocessing import Pool, Value, parent_process

# executing some commands
import subprocess

# file/directory handling
import os

# most recent starttime for program
import time

# randomness
from random import randint

# typing hints
from typing import Any, Optional

# temporary file/directory management
import tempfile

# working with sound files
import soundfile

# loudness normalization
import pyloudnorm

# file copy
import shutil

# signal handling
import signal

"""
Normalize loudness of all music files in a given directory and its subdirectories.
"""

musicfile_extensions = (".flac", ".wav", ".mp3", ".m4a", ".aac", ".opus")


class CleanupRequired(Exception):
    pass


def sigint_handler(signum, frame):
    # set workers to clean up
    cleanup_required.value = 1
    # Output only once
    if parent_process() is None:
        print("\nReceived KeyboardInterrupt. Process cleaning up and stopping...")


def loudnorm(inputfile: str, outputfile: str):
    """
    Normalize audio to EBU R 128 standard using pyloudnorm

    Parameters:
        inputfile (str): Path to input file. Format must be supported by python-soundfile module
        outputfile (str): Path to output file
    """
    data, rate = soundfile.read(file=inputfile)

    # measure loudness
    meter = pyloudnorm.Meter(rate=rate)
    loudness = meter.integrated_loudness(data=data)

    # cleanup check
    if bool(cleanup_required.value):
        raise CleanupRequired()

    # normalize audio
    file_normalized = pyloudnorm.normalize.loudness(
        data=data, input_loudness=loudness, target_loudness=-18.0
    )

    # write normalized audio to file
    soundfile.write(file=outputfile, data=file_normalized, samplerate=rate)


def ffmpeg_to_wav(inputfile: str, outputfile: str):
    """
    Convert a file into .wav for further processing

    Parameters:
        inputfile (str): Path to input file
        outputfile (str): Path to output file
    """
    # cleanup check
    if bool(cleanup_required.value):
        raise CleanupRequired()

    # convert to wav in temporary directory
    with tempfile.TemporaryDirectory() as tempdir:
        # temporary input file
        temp_input: str = os.path.join(
            tempdir, os.path.splitext(os.path.basename(inputfile))[0] + ".wav"
        )

        # temporary output file
        temp_output: str = os.path.join(
            tempdir,
            "normalized",
            os.path.splitext(os.path.basename(inputfile))[0] + ".wav",
        )
        os.mkdir(os.path.join(tempdir, "normalized"))

        # convert audio to wav
        ff = ffmpy.FFmpeg(
            inputs={inputfile: None}, outputs={temp_input: None}, global_options=("-y")
        )

        subprocess.run(ff.cmd, shell=True, capture_output=True)

        # cleanup check
        if bool(cleanup_required.value):
            raise CleanupRequired()

        # normalize loudness
        loudnorm(inputfile=temp_input, outputfile=temp_output)

        # convert audio back to lossy format
        outputcmd = {outputfile: "-c:a libopus -b:a 192k -compression_level 10"}

        # cleanup check
        if bool(cleanup_required.value):
            raise CleanupRequired()

        ff = ffmpy.FFmpeg(
            inputs={temp_output: None}, outputs=outputcmd, global_options=("-y")
        )

        subprocess.run(ff.cmd, shell=True, capture_output=True)


def ffmpeg_copy_metadata(inputfile: str, outputfile: str):
    """
    Copy all metadata from the input file to the output file.
    A temporary file is used in an intermediate step

    Parameters:
        inputfile (str): Path to input file
        outputfile (str): Path to output file
    """
    # cleanup check
    if bool(cleanup_required.value):
        raise CleanupRequired()

    # store output file as temporary file. FFMPEG can't work on files in-place
    with tempfile.NamedTemporaryFile() as temp_audio:
        shutil.copyfile(outputfile, temp_audio.name)

        # get input file extension
        extension = os.path.splitext(os.path.basename(inputfile))[1]

        inputcmd = {inputfile: None, temp_audio.name: None}

        # NOTE opus maps metadata to the first audio stream. Other formats like flac, mp3 and m4a/aac by contrast map it to the input directly
        if extension == ".opus":
            outputcmd = {outputfile: "-map 1 -c copy -map_metadata 0:s"}
        else:
            outputcmd = {outputfile: "-map 1 -c copy -map_metadata 0"}

        ff = ffmpy.FFmpeg(inputs=inputcmd, outputs=outputcmd, global_options=("-y"))

        subprocess.run(ff.cmd, shell=True, capture_output=True)


def main(inputfile: str) -> Optional[list[Any]]:
    """
    Main program loop

    Parameters:
        inputfile (str): Path to input file

    Output:
        dynamically normalised audio files (list)
    """
    # set output folder to parent path + "normalized"
    outputfolder = os.path.join(os.path.dirname(inputfile), "normalized")

    # cleanup check
    if bool(cleanup_required.value):
        raise CleanupRequired()

    # NOTE create output folder
    # because multiple parallel processes are at work here,
    # there might be conflicts with one trying to create the directory although it already exists
    # this while loop makes sure the directory does exist
    # the try/except block ensures the error is caught and (hopefully) doesn't happen again just after with random sleep
    # there's very likely a better way to do this, idk
    while not os.path.isdir(outputfolder):
        try:
            os.mkdir(outputfolder)
        except:
            time.sleep(randint(0, 4))

    # output file path
    infile_noextension: str = os.path.splitext(os.path.basename(inputfile))[0]
    infile_extension: str = os.path.splitext(os.path.basename(inputfile))[1]

    match infile_extension:
        case ".flac" | ".wav":
            print("Working on", inputfile)
            outputfile: str = os.path.join(outputfolder, infile_noextension + ".flac")
            # direct conversion start
            loudnorm(inputfile=inputfile, outputfile=outputfile)
            ffmpeg_copy_metadata(inputfile=inputfile, outputfile=outputfile)
            print("Completed", inputfile)
        case ".mp3" | ".m4a" | ".aac" | ".opus":
            print("Working on", inputfile)
            outputfile: str = os.path.join(outputfolder, infile_noextension + ".opus")
            # conversion is started within the ffmpeg_to_wav function
            ffmpeg_to_wav(inputfile=inputfile, outputfile=outputfile)
            ffmpeg_copy_metadata(inputfile=inputfile, outputfile=outputfile)
            print("Completed", inputfile)
        case _:
            print(
                inputfile,
                "does not use a known extension. This error shouldn't be happening actually",
            )
            return


if __name__ == "__main__":
    """
    Handle arguments and other details for interactive usage
    """
    # global cleanup variable
    cleanup_required = Value("i", 0)

    # handle KeyboardInterrupt
    _ = signal.signal(signal.SIGINT, sigint_handler)

    # start time of program
    starttime = time.time()

    parser = argparse.ArgumentParser(description="")

    # Input directory
    _ = parser.add_argument(
        "-i", "--input-dir", required=True, type=str, help="Input source directory"
    )

    # number of cpus/threads to use, defaults to all available
    _ = parser.add_argument(
        "-c",
        "--cpu-count",
        required=False,
        type=int,
        help="Number of cpu cores",
        default=multiprocessing.cpu_count(),
    )

    # in case you wanted to rerun the conversion for everything
    _ = parser.add_argument(
        "-r",
        "--reset",
        required=False,
        action="store_true",
        help="Rerun conversion for all files",
    )

    args = parser.parse_args()

    srcfolder = args.input_dir

    cpu = args.cpu_count

    reset = args.reset

    # file where last run timestamp is stored
    timefile = os.path.join(srcfolder, "run.time")

    # get time of previous run
    if reset:
        timeprev = 0
    elif os.path.isfile(timefile):
        with open(timefile, "r") as file:
            timeprev = file.read()
    else:
        timeprev = 0

    musicfiles: list[str] = []
    for root, dirs, files in os.walk(srcfolder):
        # ignore the "normalized" subfolder
        dirs[:] = [d for d in dirs if d not in ["normalized"]]
        for file in files:
            if file.endswith(musicfile_extensions):
                filepath = os.path.join(root, file)
                # only file newer than the last run are added
                if os.path.getmtime(filepath) >= float(timeprev):
                    musicfiles.append(filepath)

    # process pool
    with Pool(cpu) as p:
        result = p.map_async(main, musicfiles)
        # wait for all processes to finish
        result.wait()

    # write this run's time into file
    with open(timefile, "w") as file:
        file.write(str(starttime))
