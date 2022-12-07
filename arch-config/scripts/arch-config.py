#!/usr/bin/env python3
import subprocess
import os
import uuid
import glob
import shutil
import filecmp
import importlib.util
import sys


def select_theme():
    """
    Function to select a different theme
    """
    pass


def update_firefox():
    """
    Function to also update firefox config
    """
    pass


def main():
    print("works")


# Set home path
home = os.path.expanduser("~")

# Check root or run as sudo
if os.getuid() != 0:
    subprocess.run("sudo -v", shell=True, check=True)

if __name__ == "__main__":
    # change to home directory
    os.chdir(home)

    # slightly random uuid for our config location
    configdir = "config-" + str(uuid.uuid1())

    # TODO remove old "config-" folder(s)

    # clone git repo
    subprocess.run(
        "git clone https://gitlab.com/RealStickman-arch/config.git {configdir}".format(
            configdir=configdir
        ),
        shell=True,
        check=True,
        stdout=subprocess.DEVNULL,
    )

    os.chdir(configdir)
    subprocess.run(
        "git checkout master", shell=True, check=True, stdout=subprocess.DEVNULL
    )
    os.chdir(home)

    # check if downloaded script is different
    if not filecmp.cmp(
        os.path.join(home, "scripts/arch-config.py"),
        os.path.join(configdir, "scripts/arch-config.py"),
    ):
        print("Found newer config file")
        spec = importlib.util.spec_from_file_location(
            "config",
            os.path.join(configdir, "scripts/arch-config.py"),
        )
        config = importlib.util.module_from_spec(spec)
        sys.modules["config"] = config
        spec.loader.exec_module(config)
        config.main()
    else:
        print("Config is up to date")
