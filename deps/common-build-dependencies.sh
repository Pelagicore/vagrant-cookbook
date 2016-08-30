#!/bin/bash
# 
# Usage: common-build-dependencies.sh
#
# Installs basic build dependencies required to build basic packages.
#

echo "Installing common build dependencies"

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
        exit $retval
    fi
}

# Common dependencies
install git cmake build-essential pkg-config


# Common for ivi-logging & pelagicore-utils
install libglib2.0-dev

# For softwarecontainer
install libdbus-c++-dev libdbus-c++-1-0v5 libdbus-1-dev libglibmm-2.4-dev libglibmm-2.4 \
    lxc-dev libpulse-dev unzip bridge-utils lcov

# For jsonparser
install libjansson-dev libjansson4 doxygen graphviz

# For softwarecontainer examples
install dbus-x11

