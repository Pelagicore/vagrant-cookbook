#!/bin/bash
# This script changes the apt mirror to use.

if [[ "$1" -ne "" ]]; then
    releaseName=$1
else 
    releaseName="testing"
fi

function install {
    packages="$@"

    retval=100
    count=0

    if [[ "$retval" -ne "0" && $count -le 5 ]]; then
        count=$count+1
        DEBIAN_FRONTEND=noninteractive apt-get -o Dpkg::Options::="--force-confnew" --force-yes -fuy install $packages
        retval=$?
    fi

    if [["$retval" -ne "0" ]]; then
        echo "Failed to install " $packages
        exit $retval
    fi

}

rm sources.list
install netselect-apt
sudo netselect-apt -s -o sources.list $releaseName
mv sources.list /etc/apt/sources.list

