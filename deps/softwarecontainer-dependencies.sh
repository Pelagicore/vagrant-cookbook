#!/bin/bash
# vagrant-cookbook
# Copyright (C) 2015 Pelagicore AB
#
# Permission to use, copy, modify, and/or distribute this software for
# any purpose with or without fee is hereby granted, provided that the
# above copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL
# WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR
# BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES
# OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
# WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION,
# ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS
# SOFTWARE.
#
# For further information see LICENSE
#
#
# Usage: softwarecontainer-dependencies.sh
#
# Installs dependencies for softwarecontainer
#

echo "Installing softwarecontainer dependencies"

function install {
    packages="$@"

    retval=100
    count=0

    if [[ "$retval" -ne "0" && $count -le 5 ]]; then
        count=$count+1
        DEBIAN_FRONTEND=noninteractive apt-get -o Dpkg::Options::="--force-confnew" --allow-downgrades --allow-remove-essential --allow-change-held-packages -fuy install $packages
        retval=$?
    fi
    if [[ "$retval" -ne "0" ]]; then
        exit $retval
    fi
}

# For softwarecontainer
install libdbus-1-dev libglibmm-2.4-dev libglibmm-2.4 \
        unzip bridge-utils lcov libjansson-dev libjansson4 \
        dbus-x11 libcap-dev libtool

apt-get remove --allow-downgrades --allow-remove-essential --allow-change-held-packages -fuy lxcfs lxc2 lxc-dev lxc-common

# Download and install lxc
rm -rf lxc
git clone git://github.com/lxc/lxc -b stable-2.0
cd lxc

./autogen.sh
./configure --prefix=/usr --enable-capabilities

make && make install
