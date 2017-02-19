#!/bin/bash
# vagrant-cookbook
# Copyright (C) 2016-2017 Pelagicore AB
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
# Download a certain branch of qt5 from git, and build and install.
#
# Usage: qt5-git-builder.sh
#
# Required environment variables:
# SRC_DIR: Source directory to build
# GIT_REPO: Git repository to clone
# GIT_REVISION: Git revision to check out
#
# Optional environment variables:
# WIPE_SRC_DIR: Set to 'yes' in order to rm -rf the \$SRC_DIR before building
# MAKE_COMMAND: Commands used to build the project. Defaults to "make && sudo make install"
# CONFIGURE_ARGS: Extra params to ./configure. Defaults to ""
# CMAKE_ARGS: Arguments to pass to cmake
# CMAKE_PATH: cmake executable path. Defaults to "cmake" (picked from $PATH)

if [ -z ${SRC_DIR+x} ]; then echo "SRC_DIR must be set in env"; exit; fi
if [ -z ${GIT_REPO+x} ]; then echo "GIT_REPO must be set in env"; exit; fi
if [ -z ${GIT_REVISION+x} ]; then echo "GIT_REVISION must be set in env"; exit; fi
if [ -z ${MAKE_COMMAND+x} ]; then MAKE_COMMAND="make && sudo make install"; fi
if [ -z ${CONFIGURE_ARGS+x} ]; then CONFIGURE_ARGS=""; fi

BUILD_DIR=$SRC_DIR/build

echo "Building $SRC_DIR from git repo $GIT_REPO"

if [ "$WIPE_SRC_DIR" == "yes" ]; then
    rm -rf "$SRC_DIR"
fi

git clone -b $GIT_REVISION $GIT_REPO $SRC_DIR
git pull

cd $SRC_DIR

./init-repository

if  [[ "$GIT_REVISION" != "" ]] ; then
    git reset --hard $GIT_REVISION
fi

./configure $CONFIGURE_ARGS

eval "$MAKE_COMMAND"
