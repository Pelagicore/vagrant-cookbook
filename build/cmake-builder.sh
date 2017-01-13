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
# Usage: cmake-builder.sh <srcdir> <cmakeargs> <copyflag>
#
# If copyflag is set to true, copy the vagrant directory to the srcdir
# and build, else just build whatever is there directly.
#

srcdir=$1
cmakeargs=$2
builddir=$srcdir/build

copy_vagrant=false
if [ -n "$3" ] && [ "$3" == "COPY_VAGRANT" ]; then
    copy_vagrant=true
fi

if $copy_vagrant; then
    echo "Copying $srcdir from /vagrant dir"
    sudo rm -rf $srcdir
    cp -a /vagrant $srcdir
fi

echo "Building from $srcdir in $builddir"

rm -rf $builddir
mkdir $builddir
cd $builddir
cmake ../ $cmakeargs

make && sudo make install

