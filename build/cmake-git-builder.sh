#!/bin/bash
# 
# Usage: cmake-git-builder.sh <srcdir> <gitrepo> <cmakeargs>
# 
# Download gitrepo containing a cmake build system into srcdir and build 
# in srcdir/build using cmakeargs to cmake. 
#

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

