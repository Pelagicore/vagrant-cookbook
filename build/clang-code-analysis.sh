#!/bin/bash

projname==$1
builddir=$projname/build
gitrepo=$2
cmakeargs=$3

sudo apt-get update
sudo apt-get install -y clang valgrind

sudo rm -rf $projname
git clone $gitrepo $projname
mkdir $builddir
cd $builddir
../run-scan-build.sh cmake -DCMAKE_INSTALL_PREFIX=/usr/ -DENABLE_TESTS=ON ..
../run-scan-build.sh -o scan_build_output make

