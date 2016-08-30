#!/bin/bash

DOC_DIR=$1

echo "Building documentation in $DOC_DIR"

# Build documentation
cd "$DOC_DIR"
make clean


# Not all projects have slides
make slides

# Errors are fatal from now on, these targets should always work
set -e
make html
make latexpdf
