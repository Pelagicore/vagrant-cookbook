#!/bin/bash
#
# Usage: build-images.sh <yoctodir> <images>
#
# Source the environment and build the supplied images in the yoctodir
#

YOCTO_DIR="$1"
IMAGES="$2"

echo "BitBake'ing $IMAGES in $YOCTO_DIR"

# Set up bitbake environment
cd "$YOCTO_DIR/sources/poky/"
source oe-init-build-env ../../build

# A positive exit code from now on is fatal
set -e

# Start build
time bitbake $IMAGES
