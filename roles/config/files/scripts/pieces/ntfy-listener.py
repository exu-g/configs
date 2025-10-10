#!/usr/bin/env python3

# Sends desktop notifications to a subscribed ntfy topic through libnotify/notify-send
# Help: python ntfy-listener.py --help
#
# Thanks to datalars for the original script
# https://datalars.com/2023/04/17/ntfy-send-notifications-through-libnotify-to-linux-desktop/
# Unnecessary overcomplexity added by me

# web connection
import requests

# json handling
import json

# sending notifications
import subprocess

# argument parsing
import argparse

from typing import Any


def send_msg(data: dict[str, Any]) -> None:
    """
    Send message using notify-send

    Parameters:
    data (dict[str, Any]): ntfy data parsed from JSON response
    """
    # Set message title
    ntfyTitle: str = "ntfy"
    if "title" in data:
        ntfyTitle = data["title"]

    _ = subprocess.run(
        [
            "notify-send",
            f"--icon={icon}",
            f"--app-name={appname}",
            ntfyTitle,
            data["message"],
        ]
    )


def main() -> None:
    """
    Main program loop
    """
    try:
        response = requests.get(url=f"{server}/{topic}/json", stream=True)
        for line in response.iter_lines():
            if line:
                ntfyData: dict[str, Any] = json.loads(line)
                if ntfyData["event"] == "message":
                    send_msg(data=ntfyData)
    except Exception as e:
        print(e)


if __name__ == "__main__":
    """
    Handle arguments and other details for interactive usage
    """
    parser = argparse.ArgumentParser(description="")

    # Topic
    _ = parser.add_argument("-t", "--topic", required=True, type=str, help="ntfy topic")

    # Server
    _ = parser.add_argument(
        "-s",
        "--server",
        required=False,
        type=str,
        help="Server URL. Make sure to include http:// or https://",
        default="https://ntfy.sh",
    )

    # Appname
    _ = parser.add_argument(
        "-a",
        "--appname",
        required=False,
        type=str,
        help="App name",
        default="",
    )

    # Icon
    _ = parser.add_argument(
        "-i",
        "--icon",
        required=False,
        type=str,
        help="Set an Icon. Can be a file path or system icon name",
        default="",
    )

    args = parser.parse_args()

    topic: str = args.topic
    server: str = args.server
    appname: str = args.appname
    icon: str = args.icon

    # handle keyboard interrupt
    try:
        main()
    except KeyboardInterrupt:
        exit()
