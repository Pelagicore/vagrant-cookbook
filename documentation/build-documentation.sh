#!/bin/bash

DOC_DIR=$1

echo "Building documentation in $DOC_DIR"

function install {
    packages="$@"

    retval=100
    count=0

    if [[ "$retval" -ne "0" && $count -le 5 ]]; then
        count=$count+1
        DEBIAN_FRONTEND=noninteractive apt-get -o Dpkg::Options::="--force-confnew" --force-yes -fuy install $packages
        retval=$?
    fi
}

# Install dependencies (as root)
sudo apt-get update
install git python-pip texlive-latex-base texlive-latex-recommended texlive-fonts-recommended texlive-latex-extra aspell
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
