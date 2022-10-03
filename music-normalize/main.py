#!/usr/bin/env python3

# ffmpeg wrapper
from os import sched_get_priority_max
import ffmpy

# argument parsing
import argparse

# executing some commands
import subprocess

"""
parser = argparse.ArgumentParser(description="")

# Input file
parser.add_argument("-i", "--input-file", required=True, type=str, help="Input file")

args = parser.parse_args()

inputfile = args.input_file
"""
"""
ffmpeg -y -i FalKKonE\ -\ 01\ Aria\ \(From\ \"Berserk:\ The\ Golden\ Age\ Arc\"\).flac -pass 1 -filter:a loudnorm=print_format=json -f flac /dev/null

ffmpeg -i FalKKonE\ -\ 01\ Aria\ \(From\ \"Berserk:\ The\ Golden\ Age\ Arc\"\).flac -pass 2 -filter:a loudnorm=I=-30.0:linear=true:measured_I=-4.52:measured_LRA=1.90:measured_thresh=-14.64 -c:a libopus -b:a 320k test441.opus
ffmpeg -i $FILE -c:v libx264 -b:v 4000k -pass 2 -filter:a loudnorm=linear=true:measured_I=$input_i:measured_LRA=$input_lra:measured_tp=$input_tp:measured_thresh=$input_thresh -c:a aac -b:a 256k $FILE.mkv
"""

# FIXME
inputfile = (
    '/home/marc/Downloads/FalKKonE - 01 Aria (From "Berserk: The Golden Age Arc").flac'
)
inputfile = "/home/marc/Downloads/test441.opus"


def get_format(inputfile):
    # get codec format
    # https://stackoverflow.com/a/29610897
    # this shows the codecs of all audio streams present in the file, which shouldn't matter unless you have more than one stream
    ff = ffmpy.FFprobe(
        inputs={inputfile: None},
        global_options=(
            "-v",
            "quiet",
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


def loudness_info(inputfile):
    # get format from file
    # inputformat = get_format(inputfile)
    # NOTE format is actually unnecessary here
    ff = ffmpy.FFmpeg(
        inputs={inputfile: None},
        outputs={"/dev/null": "-pass 1 -filter:a loudnorm=print_format=json -f null"},
        global_options=("-y"),
    )

    print(ff.cmd)


def convert():
    # ff = ffmpy.FFmpeg()
    pass


if __name__ == "__main__":
    loudness_info(inputfile)
