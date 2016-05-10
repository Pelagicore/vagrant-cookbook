#!/bin/bash

alias apt-get="apt-get -y --force-yes"

# Common dependencies
apt-get install -y --force-yes git cmake build-essential pkg-config

# Common for ivi-logging & pelagicore-utils
apt-get install -y libglib2.0-dev

# For pelagicontain
apt-get install -y libdbus-c++-dev libdbus-c++-1-0v5 libdbus-1-dev libglibmm-2.4-dev libglibmm-2.4 \
    lxc-dev libpulse-dev unzip bridge-utils lcov

# For jsonparser
apt-get install -y libjansson-dev libjansson4

# For pelagicontain examples
apt-get install -y dbus-x11

