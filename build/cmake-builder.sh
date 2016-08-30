#!/bin/bash
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

echo "Building in $srcdir"

rm -rf $builddir
mkdir $builddir
cd $builddir
cmake .. $cmakeargs
make && sudo make install

