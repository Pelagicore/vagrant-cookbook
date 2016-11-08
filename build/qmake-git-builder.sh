#!/bin/bash
# vagrant-cookbook
# Copyright (C) 2016 Pelagicore AB
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
# Usage: qmake-git-builder.sh <srcdir> <gitrepo> <qmakepath> <qmakeargs> \
#              <.pro file> [revision] [make command]
# 
# Download git repo containing a qmake build system into srcdir and build 
# in srcdir/build using qmakeargs to qmake. 
#
# The optional make command argument can be used to specify which commands should
# be executed to build the source code. If nothing is specified it will run: make && sudo make install

srcdir=$1
builddir=$srcdir/build
gitrepo=$2
qmakepath=$3
qmakeargs=$4
projectfile=$5
rev=$6
makecommand=$7

echo "Building $srcdir from git repo $gitrepo"

rm -rf $srcdir
git clone $gitrepo $srcdir
if  [[ "${rev}" != "" ]] ; then
    cd $srcdir
    git reset --hard $rev
    cd ..
fi
mkdir $builddir
cd $builddir
$qmakepath ../$projectfile $qmakeargs
if  [[ "$makecommand" != "" ]] ; then
    eval "$makecommand"
else
    make && sudo make install
fi

