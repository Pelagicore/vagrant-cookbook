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
cmake .. $cmakeargs
make && sudo make install

