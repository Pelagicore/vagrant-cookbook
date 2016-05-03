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

# Build documentation
cd "$DOC_DIR"
make clean

# Errors are fatal from now on
set -e
make html
make latexpdf
