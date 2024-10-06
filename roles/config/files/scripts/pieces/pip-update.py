#!/usr/bin/env python3
import pkg_resources
import subprocess

# get a list of all packages installed
packages = [dist.project_name for dist in pkg_resources.working_set]

# update each package
for package in packages:
    subprocess.call("pip install --upgrade {}".format(package), shell=True)
