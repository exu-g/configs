# Presets for setup and config installation

# List all available recipes
help:
    @just --list --justfile {{justfile()}}

# first time setup
setup:
    ansible-playbook setup.yml --tags all

# copy configs and services
config:
    ansible-playbook setup.yml --tags "config,services"

# install packages
packages:
    ansible-playbook setup.yml --tags "packages"
