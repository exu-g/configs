# Presets for setup and config installation

# List all available recipes
help:
    @just --list --justfile {{justfile()}}

# first time setup
setup:
    ansible-playbook setup.yml --tags all --ask-become-pass

# copy configs and services
config:
    ansible-playbook setup.yml --tags "config,services" --ask-become-pass

# install packages
packages:
    ansible-playbook setup.yml --tags "packages" --ask-become-pass
