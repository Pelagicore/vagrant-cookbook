#!/bin/bash
# This script upgrades a system from jessie to testing

alias apt-get="apt-get -y --force-yes"
# Several packages need to be very recent, so use debian testing
sed -i 's/jessie/testing/g' /etc/apt/sources.list
apt-get update
DEBIAN_FRONTEND=noninteractive apt-get -o Dpkg::Options::="--force-confnew" --force-yes -fuy dist-upgrade
apt-get -y --force-yes autoremove

