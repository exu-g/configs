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

"""

"""

# FIXME
# inputfile = (
#    '/home/marc/Downloads/FalKKonE - 01 Aria (From "Berserk: The Golden Age Arc").flac'
# )
# inputfile = "/home/marc/Downloads/test441.opus"
# outputfile = "/home/marc/Downloads/test441_out.opus"

# srcfolder = "/home/marc/Downloads/MusikRaw"
# destfolder = "/home/marc/Downloads/Musik"

musicfile_extensions = (".flac", ".wav", ".mp3", ".m4a", ".aac", ".opus")


def get_format(inputfile) -> str:
    # get codec format
    # https://stackoverflow.com/a/29610897
    # this shows the codecs of all audio streams present in the file, which shouldn't matter unless you have more than one stream
    ff = ffmpy.FFprobe(
        inputs={inputfile: None},
        global_options=(
            "-v quiet",
            "-select_streams a",
            "-show_entries stream=codec_name",
            "-of default=noprint_wrappers=1:nokey=1",
        ),
    )
    # print(ff.cmd)
    proc = subprocess.Popen(ff.cmd, shell=True, stdout=subprocess.PIPE)
    # NOTE read output from previous command
    # rstrip: remove trailing newline
    # decode: convert from binary string to normal string
    format: str = (
        proc.stdout.read()  # pyright: ignore[reportOptionalMemberAccess]
        .rstrip()
        .decode("utf8")
    )
    # print(format)
    return format


def remove_picture(inputfile):
    """
    This function makes sure no image is attached to the audio stream.
    An image might cause problems for the later conversion to opus.

    Parameters:
        inputfile (str): Path to file
    """
    tmpfile = os.path.splitext(inputfile)[0] + ".tmp" + os.path.splitext(inputfile)[1]
    ff = ffmpy.FFmpeg(
        inputs={inputfile: None},
        outputs={tmpfile: "-vn -c:a copy"},
        global_options=("-v error"),
    )
    ff.run()
    os.remove(inputfile)
    os.rename(tmpfile, inputfile)


def loudness_info(inputfile) -> dict[str, str]:
    print("Measuring loudness of ", os.path.basename(inputfile))
    # get format from file
    # inputformat = get_format(inputfile)
    # NOTE format is actually unnecessary here
    ff = ffmpy.FFmpeg(
        inputs={inputfile: None},
        outputs={"/dev/null": "-pass 1 -filter:a loudnorm=print_format=json -f null"},
        global_options=("-y"),
    )

    # print(ff.cmd)
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
    # print(loudness_json)
    # print(ff.cmd)
    return loudness


def convert(inputfile, outputfile, loudness):
    print("Working on ", os.path.basename(inputfile))
    # coverpath = os.path.join(os.path.dirname(inputfile), "cover.jpg")
    # NOTE including covers into ogg/opus containers currently doesn't work
    # https://trac.ffmpeg.org/ticket/4448
    inputcmd = {inputfile: None}
    outputcmd = {
        outputfile: "-pass 2"
        " "
        "-filter:a"
        " "
        "loudnorm=I=-30.0:"
        "measured_I={input_i}:"
        "measured_LRA={input_lra}:"
        "measured_tp={input_tp}:measured_thresh={input_thresh}"
        " "
        "-c:a libopus"
        " "
        "-b:a 320k".format(
            input_i=loudness["input_i"],
            input_lra=loudness["input_lra"],
            input_tp=loudness["input_tp"],
            input_thresh=loudness["input_thresh"],
        )
    }

    ff = ffmpy.FFmpeg(
        inputs=inputcmd,
        outputs=outputcmd,
        global_options=("-y", "-v error"),
    )
    # print(ff.cmd)
    ff.run()


def main(inputfile: str):
    """
    Main program loop

    Parameters:
        inputfile (str): Path to input file
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
    noext_infile: str = os.path.splitext(os.path.basename(inputfile))[0]
    outputfile: str = os.path.join(outputfolder, noext_infile + ".opus")

    # print(inputfile)
    # print(os.path.dirname(inputfile))
    # print(os.path.basename(inputfile))
    # print(outputfile)

    # remove_picture(inputfile=inputfile)
    loudness = loudness_info(inputfile=inputfile)
    convert(inputfile=inputfile, outputfile=outputfile, loudness=loudness)


if __name__ == "__main__":
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

    # get time of previous run
    if reset:
        timeprev = 0
    elif os.path.isfile(timefile):
        with open(timefile, "r") as file:
            timeprev = file.read()
    else:
        timeprev = 0

    # print(timeprev)

    musicfiles = []
    for root, dirs, files in os.walk(srcfolder):
        # ignore the "normalized" subfolder
        dirs[:] = [d for d in dirs if d not in ["normalized"]]
        for file in files:
            if file.endswith(musicfile_extensions):
                filepath = os.path.join(root, file)
                # only file newer than the last run are added
                if os.path.getmtime(filepath) >= float(timeprev):
                    musicfiles.append(os.path.join(root, file))

    # print(musicfiles)

    with Pool(cpu) as p:
        p.map(main, musicfiles)

    # write this run's time into file
    with open(timefile, "w") as file:
        file.write(str(starttime))
