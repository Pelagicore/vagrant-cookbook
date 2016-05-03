#!/bin/bash

YOCTO_DIR="$1"
IMAGES="$2"
COUNTER=100

echo "Fetching all the sources. Try $COUNTER times in case of a bad connection."

# Set up bitbake environment
cd "$YOCTO_DIR/sources/poky/"
source oe-init-build-env ../../build

COUNTER=0
while [  $COUNTER -lt $COUNTER ]; do
    echo COUNTER $COUNTER
    let COUNTER+=1
    sleep 1
    time bitbake -c fetchall $IMAGES
    if [ $? -eq 0 ]; then
        break
    fi
done
