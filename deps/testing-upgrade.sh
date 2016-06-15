#!/bin/bash
# This script upgrades a system from jessie to testing

echo "Performing upgrade of system to testing"

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

# Several packages need to be very recent, so use debian testing
sed -i 's/jessie/testing/g' /etc/apt/sources.list
if ! grep -q "contrib" /etc/apt/sources.list; then
    sed -i 's/main/main contrib/g' /etc/apt/sources.list
fi
sed -i 's/httpredir/ftp.se/g' /etc/apt/sources.list


aptrunner update
aptrunner dist-upgrade
aptrunner autoremove

# Reinstall for the new kernel, this ensures things will work after reboot
install virtualbox-guest-utils
