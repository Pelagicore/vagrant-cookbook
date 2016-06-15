#!/bin/bash

srcdir=$1
builddir=$srcdir/build
gitrepo=$2
cmakeargs=$3

echo "Building $srcdir from git repo $gitrepo"

rm -rf $srcdir
git clone $gitrepo $srcdir
mkdir $builddir
cd $builddir

# If CMAKE_INSTALL_PREFIX is not set, we set it to /usr
if grep -q "-DCMAKE_INSTALL_PREFIX=" <<< $cmakeargs; then
    cmake ../ $cmakeargs
else
    cmake .. $cmakeargs -DCMAKE_INSTALL_PREFIX=/usr
fi
make && sudo make install

