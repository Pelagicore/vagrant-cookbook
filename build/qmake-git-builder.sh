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
# Download git repo containing a qmake build system into srcdir and build
# in srcdir/build using qmakeargs to qmake.
#
# Usage: qmake-git-builder.sh
#
# Required environment variables:
# SRC_DIR: Source directory to build
# GIT_REPO: Git repository to clone
#
# Optional environment variables:
# PRO_FILE: Project file to build with qmake (defaults to "../")
# WIPE_SRC_DIR: Set to 'yes' in order to rm -rf the \$SRC_DIR before building
# ENABLE_SUBMODULES: Set to 'yes' in order to perform a git submodule update
#     --init in the repository before building
# MAKE_COMMAND: Commands used to build the project. Defaults to "make && sudo make install"
# QMAKE_ARGS: Arguments to pass to qmake. Defaults to ""
# QMAKE_PATH: Full path to qmake. Defaults to "qmake" (picked from $PATH)
# GIT_REVISION: Git revision to check out

if [ -z ${SRC_DIR+x} ]; then echo "SRC_DIR must be set in env"; exit; fi
if [ -z ${GIT_REPO+x} ]; then echo "GIT_REPO must be set in env"; exit; fi
if [ -z ${PRO_FILE+x} ]; then PRO_FILE="../"; fi
if [ -z ${MAKE_COMMAND+x} ]; then MAKE_COMMAND="make && sudo make install"; fi
if [ -z ${QMAKE_ARGS+x} ]; then QMAKE_ARGS=""; fi
if [ -z ${QMAKE_PATH+x} ]; then QMAKE_PATH="qmake"; fi

BUILD_DIR="$SRC_DIR/build"

echo "Building $SRC_DIR from git repo $GIT_REPO"

if [ "$WIPE_SRC_DIR" == "yes" ]; then
    rm -rf "$SRC_DIR"
fi

git clone "$GIT_REPO" "$SRC_DIR"
pushd "$SRC_DIR"
git pull
if [ "$ENABLE_SUBMODULES" == "yes" ]; then
    git submodule update --init
fi
popd

mkdir "$BUILD_DIR"
cd "$BUILD_DIR"

if [ "$GIT_REVISION" != "" ]; then
    git reset --hard $GIT_REVISION
fi

$QMAKE_PATH "$PRO_FILE" $QMAKE_ARGS
eval "$MAKE_COMMAND"
