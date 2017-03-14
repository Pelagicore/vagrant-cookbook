#!/bin/bash
# vagrant-cookbook
# Copyright (C) 2015-2017 Pelagicore AB
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
# Usage: setup-ccache-and-icecc.sh
#
# Installs and configures ccache and icecc
#

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
        echo "Failed to install " $packages
        exit $retval
    fi

}

install ccache icecc

#
# According to the ccache and icecc docs, combining these two is best done the following way:
# 1) Make sure ccache is before your compiler in the PATH
# 2) Set CCACHE_PREFIX to icecc. This will make ccache call icecc when there is a cache miss
#
# If you want to use clang, set CC and CXX (since they take precedence). This works together with
# the icecc and ccache setup. However, if you use update-alternatives to select clang, it fails
# for some reason.
#

# In case one wants to install clang, it will be ready to use with icecc
if ! [ -e "/usr/lib/icecc/bin/clang" ]; then
    pushd /usr/lib/icecc/bin
    ln -s $(which icecc) clang
    ln -s $(which icecc) clang++
    popd
fi

# And in case one wants to install clang, it will be ready to use with ccache
if ! [ -e "/usr/lib/ccache/clang" ]; then
    pushd /usr/lib/ccache
    ln -s $(which ccache) clang
    ln -s $(which ccache) clang++
    popd
fi

# Only set these things if they were not already set.
if ! grep "HAS_ICECC" /etc/profile; then
    # Make sure the ccache symbolic links are first in our $PATH
    echo 'export PATH=/usr/lib/ccache:$PATH' >> /etc/profile
    # Make sure ccache calls icecc when it tries to compile
    echo "export CCACHE_PREFIX=icecc" >> /etc/profile
    # Something for other scripts to check for
    echo "export HAS_ICECC=true" >> /etc/profile

    # Some default make flags
    # Special case for only one CPU
    MAX_LOAD=$(($(nproc)+2))
    if [ "$MAX_LOAD" -eq 3 ]; then
        MAX_LOAD=2
    fi
    echo "export MAKEFLAGS=\"-j -l${MAX_LOAD}\"" >> /etc/profile
fi

# Don't accept remote jobs
sed -i -e 's/ICECC_ALLOW_REMOTE="yes"/ICECC_ALLOW_REMOTE="no"/' /etc/icecc/icecc.conf

