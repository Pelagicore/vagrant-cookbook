#!/bin/bash

srcdir=$1
builddir=$srcdir/build
cmakeargs=$2

echo "Building $srcdir from /vagrant dir"

rm -rf $srcdir
cp -a /vagrant $srcdir
rm -rf $builddir
mkdir $builddir
cd $builddir
cmake .. $cmakeargs
make && sudo make install

