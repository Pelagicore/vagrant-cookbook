#!/bin/bash
# This script changes the apt mirror to use.

function aptrunner {
    cmd="$1"
    retval=100
    count=0
    if [[ "$retval" -ne "0" && $count -le 5 ]]; then
        count=$count+1
        export DEBIAN_FRONTEND=noninteractive
        if [ "$cmd" == "update" ] ; then
            flags="-uy"
        else 
            flags="-fuy"
        fi
        cmdline="apt-get -o Dpkg::Options::="--force-confnew" --force-yes $flags $cmd"
        echo "Running $cmdline"
        $cmdline
        retval=$?
    fi
}

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

rm sources.list
install netselect-apt
sudo netselect-apt -s -o sources.list testing
mv sources.list /etc/apt/sources.list

aptrunner update
aptrunner dist-upgrade
aptrunner autoremove
