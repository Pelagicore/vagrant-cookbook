#!/bin/bash

echo "Installing common run dependencies"

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

# For dbus-proxy
install libdbus-glib-1-dev

# For pelagicontain unit tests
install pulseaudio alsa-utils
