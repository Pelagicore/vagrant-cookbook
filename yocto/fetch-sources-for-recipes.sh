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

YOCTO_DIR="$1"
IMAGES="$2"
COUNTER=100

# Set up bitbake environment
echo "Setting up bitbake environment."
cd "$YOCTO_DIR/sources/poky/"
source oe-init-build-env ../../build

# Fetch all sources
echo "Fetching all the sources. Will try $COUNTER times in case of a bad connection."
I=0
while [  $I -lt $COUNTER ]; do
    echo "Try number: $I"
    let I+=1
    sleep 1
    time bitbake -c fetchall $IMAGES
    if [ $? -eq 0 ]; then
        break
    fi
done
