#!/bin/bash
# 
# Usage: common-api-yocto.sh
# 
# Installs all the packages required to build common api in yocto. 

echo "Installing version control system dependencies" 

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

install maven
