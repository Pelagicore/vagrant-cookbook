#!/bin/bash

srcdir=$1
builddir=$srcdir/build
cmakeargs=$2

echo "Building $srcdir from git repo $gitrepo"

rm -rf $srcdir
cp -a /vagrant $srcdir
mkdir $builddir
cd $builddir
cmake .. $cmakeargs
make && sudo make install

