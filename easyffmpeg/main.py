#!/usr/bin/env python3

# ffmpeg wrapper
import subprocess
import ffmpy

# argument parsing
import argparse

parser = argparse.ArgumentParser(description="")

# Input file
parser.add_argument("-i", "--input-file", required=True, type=str, help="Input file")

# Media title
parser.add_argument("-t", "--title", required=True, type=str, help="Media title")

# Video stuff
parser.add_argument(
    "-vc",
    "--video-codec",
    required=False,
    type=str,
    help="Output video codec. Defaults to 'copy'",
)
parser.add_argument(
    "-crf",
    "--crf",
    required=False,
    type=int,
    help="Codec crf. No effect if video codec is 'copy'. Defaults to 20",
)
parser.add_argument(
    "-vt", "--video-tune", required=False, type=str, help="Video codec tune"
)
parser.add_argument(
    "-vp",
    "--video-preset",
    required=False,
    type=str,
    help="Video compression preset. Defaults to 'medium'",
)

# Audio stuff
parser.add_argument(
    "-ac",
    "--audio-codec",
    required=False,
    type=str,
    help="Output audio codec. Defaults to 'copy'",
)
parser.add_argument(
    "-ab",
    "--audio-bitrate",
    required=False,
    type=str,
    help="Output audio bitrate. No effect if audio codec is 'copy'. Defaults to '192k'",
)
parser.add_argument(
    "-aj",
    "--audio-japanese",
    required=True,
    type=str,
    help="Stream identifier for japanese audio",
)
parser.add_argument(
    "-ae",
    "--audio-english",
    required=False,
    type=str,
    help="Stream identifier for english audio",
)

# Subtitle stuff
parser.add_argument(
    "-sn", "--subtitle-name", required=True, type=str, help="Name for subtitles"
)
parser.add_argument(
    "-si",
    "--subtitle-stream",
    required=True,
    type=str,
    help="Stream identifier for subtitles",
)

# Output file
parser.add_argument("-o", "--output-file", required=True, type=str, help="Output file")

# Execute or print commands
parser.add_argument(
    "-e",
    "--execute",
    action="store_true",
    help="Execute script. If not set, shows the commands that would be run.",
)

args = parser.parse_args()

title = args.title

inputfile = args.input_file

# Default video codec is copy
if args.video_codec is None:
    videocodec = "copy"
else:
    videocodec = args.video_codec

# Default crf of 20
if args.crf is None:
    crf = 20
else:
    crf = args.crf

if args.video_tune is None:
    tune = ""
else:
    tune = "-tune " + args.video_tune

if args.video_preset is None:
    preset = "medium"
else:
    preset = args.video_preset

# Default audio codec is copy
if args.audio_codec is None:
    audiocodec = "copy"
else:
    audiocodec = args.audio_codec

# Default audio codec is copy
if args.audio_bitrate is None:
    audiobitrate = "192k"
else:
    audiobitrate = args.audio_bitrate

outputfile = args.output_file

japaneseaudio = args.audio_japanese

# Map english audio, if set
if args.audio_english is None:
    englishaudio = ""
else:
    englishaudio = "-map " + args.audio_english

subtitle = args.subtitle_name
subtitlestream = args.subtitle_stream

# Flag to actually execute command
execute = args.execute

# NOTE Breaks if filename contains quotes: '
ff = ffmpy.FFmpeg(
    inputs={inputfile: None},
    outputs={
        outputfile: "-metadata title='{title}' -disposition 0"
        " "
        "-c:v {videocodec} -crf {crf} {tune} -preset {preset} -map 0:v:0 -metadata:s:v:0 title='Video' -disposition:v:0 default"
        " "
        "-c:a {audiocodec} -b:a {audiobitrate} -map {jpnaudiostream}? {engaudiomap}"
        " "
        "-metadata:s:a:0 title='Japanese' -metadata:s:a:0 language=jpn -metadata:s:a:1 title='English' -metadata:s:a:1 language=eng -disposition:a:0 default"
        " "
        "-c:s copy -map {substream} -metadata:s:s:0 title='{subtitle}' -metadata:s:s:0 language=eng -disposition:s:0 default"
        " ".format(
            title=title,
            videocodec=videocodec,
            crf=crf,
            tune=tune,
            preset=preset,
            audiocodec=audiocodec,
            audiobitrate=audiobitrate,
            jpnaudiostream=japaneseaudio,
            engaudiomap=englishaudio,
            substream=subtitlestream,
            subtitle=subtitle,
        )
    },
)

if execute:
    ff.run()
else:
    print(ff.cmd)

# NOTE check all files for an intact/valid duration
# Valid file example output:
# {
#     "format": {
#         "duration": "1425.058000"
#     }
# }
# Invalid file:
# {
#     "format": {
#
#     }
# }
ff = ffmpy.FFprobe(
    inputs={outputfile: None},
    global_options=("-show_entries format=duration -v quiet -print_format json"),
)

proc = subprocess.Popen(
    ff.cmd, stderr=subprocess.STDOUT, stdout=subprocess.PIPE, shell=True
)

# TODO continue here
print(proc.stdout.read().rstrip().decode("utf8"))
