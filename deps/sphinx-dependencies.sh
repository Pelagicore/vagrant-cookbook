#!/bin/bash

function install {
    packages="$@"

    retval=100
    count=0

    if [[ "$retval" -ne "0" && $count -le 5 ]]; then
        count=$count+1
        DEBIAN_FRONTEND=noninteractive apt-get -o Dpkg::Options::="--force-confnew" --force-yes -fuy install $packages
        retval=$?
    fi

    if [[ "$retval" -ne "0" ]]; then
        echo "Failed to install " $packages
        exit $retval
    fi
}

# Install dependencies (as root)
sudo apt-get update
install git python-pip texlive-latex-base texlive-latex-recommended texlive-fonts-recommended texlive-latex-extra texlive-generic-extra aspell

# Install Sphinx (as root)
sudo pip install Sphinx
sudo pip install sphinxcontrib-manpage
sudo pip install hieroglyph

