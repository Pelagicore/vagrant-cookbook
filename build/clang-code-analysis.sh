#!/bin/bash

projname=$1
builddir=$projname/build
cmakeargs=$2

sudo apt-get update
sudo apt-get install -y clang valgrind

sudo rm -rf $projname
cp -a /vagrant $projname 
mkdir $builddir
cd $builddir
../run-scan-build.sh cmake -DCMAKE_INSTALL_PREFIX=/usr/ -DENABLE_TESTS=ON ..
../run-scan-build.sh -o scan_build_output make

