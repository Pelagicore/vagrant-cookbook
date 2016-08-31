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

