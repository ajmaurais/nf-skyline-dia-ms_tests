#!/bin/bash

# This script accepts directories as arguments.
# It will ask for confirmation before cleaning each directory, unless
# the force option (-f, --force) is used.
# Use -h or --help to display usage information.

force=false

usage() {
    cat <<EOF
Usage: $0 [OPTIONS] directory [directory...]
Options:
  -f, --force     Do not prompt for confirmation; force deletion.
  -h, --help      Display this help message and exit.
EOF
}

# Parse options using getopt (which supports long options).
ARGS=$(getopt -o hf -l help,force -n "$0" -- "$@")
if [ $? -ne 0 ]; then
    usage
    exit 1
fi
eval set -- "$ARGS"

while true; do
    case "$1" in
        -h|--help)
            usage
            exit 0
            ;;
        -f|--force)
            force=true
            shift
            ;;
        --)
            shift
            break
            ;;
        *)
            break
            ;;
    esac
done

# Check that at least one directory is provided
if [ "$#" -eq 0 ]; then
    usage
    exit 1
fi

# Process each directory given as argument
for d in "$@"; do
    echo "Processing directory: $d"
    
    # Check if the directory exists
    if [ ! -d "$d" ]; then
        echo "Error: Directory '$d' does not exist. Skipping."
        continue
    fi

    # If not forced, ask for confirmation per directory
    if ! $force ; then
        read -p "Are you sure you want to delete contents in '$d'? (y/N): " answer
        answer=$(echo "$answer" | tr '[:upper:]' '[:lower:]')
        if [ "$answer" != "y" ]; then
            echo "Skipping '$d'."
            continue
        fi
    fi

    # Change to the directory (with output from pushd and popd) and perform removals
    pushd "$d" || continue
    rm -rf work/* reports/*
    rm -rfv results/* .nextflow.*
    popd

    echo "Finished processing '$d'."
done
