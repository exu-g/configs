#!/usr/bin/env python3

# ffmpeg wrapper
import multiprocessing
from os.path import isdir, isfile
import ffmpy

# argument parsing
import argparse

# multiprocessing stuff
from multiprocessing import Pool
from multiprocessing import cpu_count

# executing some commands
import subprocess

# parsing json output of loudnorm
import json

# file/directory handling
import os

# most recent starttime for program
import time

from random import randint

from typing import Any, Optional

"""

"""

musicfile_extensions = (".flac", ".wav", ".mp3", ".m4a", ".aac", ".opus")


def loudness_info(inputfile) -> dict[str, str]:
    """
    Measure loudness of the given input file

    Parameters:
        inputfile

    Output:
        loudness (dict[str, str]): decoded json dictionary containing all loudness information
    """

    print("Measuring loudness of ", os.path.basename(inputfile))

    ff = ffmpy.FFmpeg(
        inputs={inputfile: None},
        outputs={"/dev/null": "-pass 1 -filter:a loudnorm=print_format=json -f null"},
        global_options=("-y"),
    )

    proc = subprocess.Popen(
        ff.cmd, shell=True, stderr=subprocess.STDOUT, stdout=subprocess.PIPE
    )

    # NOTE get loudness info from subprocess
    # rstrip: remove trailing newline
    # decode: convert from binary string to utf8
    # splitlines: list of lines (only 12 last ones, length of the output json)
    # join: reassembles the list of lines and separates with "\n"
    loudness_json: str = "\n".join(
        proc.stdout.read().rstrip().decode("utf8").splitlines()[-12:]
    )
    # decode json to dict
    loudness: dict[str, str] = json.loads(loudness_json)
    return loudness


def convert(
    inputfile: str,
    outputfile: str,
    codec: str,
    compression: int,
    loudness: dict[str, str],
    bitrate: str = "0k",
) -> Optional[list[Any]]:
    """
    Convert the input file to the desired format

    Parameters:
        inputfile (str)
        outputfile (str)
        loudness (dict[str, str])

    Output:
        dynamically normalised files (list)
    """

    print("Working on ", os.path.basename(inputfile))

    # NOTE including covers into ogg/opus containers currently doesn't work
    # https://trac.ffmpeg.org/ticket/4448
    inputcmd = {inputfile: None}
    # NOTE bitrate is set to 0k when converting to flac. This does not have any effect however and is simply ignored
    outputcmd = {
        outputfile: "-pass 2"
        " "
        "-filter:a"
        " "
        "loudnorm=I=-30.0:"
        "LRA=10.0:"
        "measured_I={input_i}:"
        "measured_LRA={input_lra}:"
        "measured_tp={input_tp}:measured_thresh={input_thresh}:"
        "print_format=json"
        " "
        "-c:a {codec}"
        " "
        "-b:a {bitrate}"
        " "
        "-compression_level {compression}".format(
            input_i=loudness["input_i"],
            input_lra=loudness["input_lra"],
            input_tp=loudness["input_tp"],
            input_thresh=loudness["input_thresh"],
            codec=codec,
            bitrate=bitrate,
            compression=compression,
        )
    }

    ff = ffmpy.FFmpeg(
        inputs=inputcmd,
        outputs=outputcmd,
        global_options=("-y"),
    )

    proc = subprocess.Popen(
        ff.cmd, shell=True, stderr=subprocess.STDOUT, stdout=subprocess.PIPE
    )

    # NOTE get loudness info from subprocess
    # rstrip: remove trailing newline
    # decode: convert from binary string to utf8
    # splitlines: list of lines (only 12 last ones, length of the output json)
    # join: reassembles the list of lines and separates with "\n"
    loudness_json: str = "\n".join(
        proc.stdout.read().rstrip().decode("utf8").splitlines()[-12:]
    )

    # decode json to dict
    loudness_new: dict[str, str] = json.loads(loudness_json)
    if loudness_new["normalization_type"] != "linear":
        nonlinear: list[Any] = [inputfile, loudness_new]
        return nonlinear


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
            outputfile: str = os.path.join(outputfolder, infile_noextension + ".flac")
            codec: str = "flac"
            compression: int = 12  # best compression
            bitrate: str = "0k"
        case ".mp3" | ".m4a" | ".aac" | ".opus":
            outputfile: str = os.path.join(outputfolder, infile_noextension + ".opus")
            codec: str = "libopus"
            compression: int = 10  # best compression
            bitrate: str = "192k"
        case _:
            print(inputfile, "does not use a known extension. Conversion skipped")
            return

    loudness: dict[str, str] = loudness_info(inputfile=inputfile)
    nonlinear: Optional[list[Any]] = convert(
        inputfile=inputfile,
        outputfile=outputfile,
        codec=codec,
        compression=compression,
        loudness=loudness,
        bitrate=bitrate,
    )

    return nonlinear


if __name__ == "__main__":
    """
    Handle arguments and other details for interactive usage
    """
    # start time of program
    starttime = time.time()

    parser = argparse.ArgumentParser(description="")

    # Input directory
    parser.add_argument(
        "-i", "--input-dir", required=True, type=str, help="Input source directory"
    )

    # number of cpus/threads to use, defaults to all available
    parser.add_argument(
        "-c",
        "--cpu-count",
        required=False,
        type=int,
        help="Number of cpu cores",
        default=multiprocessing.cpu_count(),
    )

    # in case you wanted to rerun the conversion for everything
    parser.add_argument(
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

    # list of non-linear normalizations
    nonlinear_all: Optional[list[Any]] = []

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
                    musicfiles.append(os.path.join(root, file))

    with Pool(cpu) as p:
        nonlinear_all: Optional[list[Any]] = p.map(main, musicfiles)

    # write this run's time into file
    with open(timefile, "w") as file:
        file.write(str(starttime))

    print("Dynamically normalized music:")
    for i in nonlinear_all:
        # NOTE ignore empty and "None" values
        if i:
            print(i)
