#!/bin/bash

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

# If CMAKE_INSTALL_PREFIX is not set, we set it to /usr
if grep -q "-DCMAKE_INSTALL_PREFIX=" <<< $cmakeargs; then
    cmake ../ $cmakeargs
else
    cmake .. $cmakeargs -DCMAKE_INSTALL_PREFIX=/usr
fi
make && sudo make install

