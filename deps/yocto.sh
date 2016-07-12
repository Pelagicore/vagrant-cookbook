#!/bin/bash
# Install dependencies needed to run BitBake

echo "Installing yocto build dependencies"

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

sudo apt-get update
install git sed wget cvs subversion git-core                            \
    coreutils unzip gawk python-pysqlite2 diffstat help2man make gcc    \
    build-essential g++ chrpath libxml2-utils libsdl1.2-dev texinfo

