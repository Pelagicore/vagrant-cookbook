#!/bin/bash

DOC_DIR=$1

echo "Building documentation in $DOC_DIR"

# Install dependencies (as root)
sudo apt-get update
sudo apt-get install -y git python-pip texlive-latex-base texlive-latex-recommended texlive-fonts-recommended texlive-latex-extra aspell
sudo pip install Sphinx

# Install Sphinx (as root)
sudo pip install Sphinx
sudo pip install sphinxcontrib-manpage
sudo pip install hieroglyph

# Build documentation
cd "$DOC_DIR"
make clean


# Not all projects have slides
make slides

# Errors are fatal from now on, these targets should always work
set -e
make html
make latexpdf
