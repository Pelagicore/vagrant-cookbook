#!/bin/bash
# This script upgrades a system from jessie to testing

echo "Performing upgrade of system to testing"

function aptrunner {
    cmd="$1"
    retval=100
    count=0
    if [[ "$retval" -ne "0" && $count -le 5 ]]; then
        count=$count+1
        DEBIAN_FRONTEND=noninteractive apt-get -o Dpkg::Options::="--force-confnew" --force-yes -fuy $cmd
    fi
}


alias apt-get="apt-get -y --force-yes"
# Several packages need to be very recent, so use debian testing
sed -i 's/jessie/testing/g' /etc/apt/sources.list
aptrunner update
aptrunner dist-upgrade
aptrunner autoremove

