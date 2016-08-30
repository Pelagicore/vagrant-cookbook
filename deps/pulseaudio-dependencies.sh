#!/bin/bash
#
# Usage: pulseaudio-dependencies.sh
#
# Installs the requirements for pulseaudio and dependencies for pulseaudio 
# tests
#

echo "Installing Pulseaudio related dependencies"

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

install pulseaudio

