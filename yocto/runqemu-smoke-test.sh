#!/bin/bash
# vagrant-cookbook
# Copyright (C) 2017 Pelagicore AB
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
# Usage: smoke-test-images.sh <yoctodir> <images>
#
# Source the environment and smoke test the supplied images in the yoctodir using qemu.
# This script depends on qemu and iptables.
#

YOCTO_DIR="$1"
IMAGES="$2"

echo "BitBake'ing $IMAGES in $YOCTO_DIR"

# Set up bitbake environment
cd "$YOCTO_DIR/sources/poky/"
source oe-init-build-env ../../build

# A positive exit code from now on is fatal
set -e

# Make sure we have the required utilities
bitbake qemu-helper-native

# Set up networking for qemu
sudo ../sources/poky/scripts/runqemu-gen-tapdevs `id -u` `id -g` 4 tmp/sysroots-components/x86_64/qemu-helper-native/usr/bin

# Start smoke tests
time bitbake $IMAGES -c testimage
