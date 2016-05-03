#!/bin/bash

YOCTO_DIR="$1"
IMAGES="$2"

echo "Building Build an SDK for $IMAGES in $YOCTO_DIR"

# Set up bitbake environment
cd "$YOCTO_DIR/sources/poky/"
source oe-init-build-env ../../build

# A positive exit code from now on is fatal
set -e

# Start build
time bitbake -c populate_sdk $IMAGES
