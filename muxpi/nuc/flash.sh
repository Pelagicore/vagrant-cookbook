#!/bin/bash

# Copyright (C) 2019 Luxoft Sweden AB
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
# This script downloads, flashes the image and tests it on NUC. 
# This script must be run on muxpi.
#
# Usage: 
# $ ./flash.sh DUP_IP IMAGE [neptune]
#    DUP_IP = a string with IP, can be an empty string
#    IMAGE = a string with the name of the variant
# The default image to use is the minimal image. If you want to run the neptune image
# use the option 'neptune'.


set -e

DUT_IP="$1"
VARIANT="$2"
NEPTUNE_IMAGE="$3"

HOMEPATH="/home/muxpi"
IMAGESPATH="${HOMEPATH}/images"

if [ "$VARIANT" == "" ]; then
   echo "Specify the name of image"
   exit -1
fi

if [ "$DUT_IP" == "" ]; then
   echo "Specify DUT IP"
   exit -1;
fi

stm -ts
fota -card /dev/sda -map $HOMEPATH/artifacts/map.json $HOMEPATH/artifacts/$VARIANT
if [ $? == 0 ];then
        echo "Image '${VARIANT} successfully flashed using fota"
fi
# boot the dut
stm -dut

cd /home/muxpi/scripts
$HOMEPATH/scripts/ethup.sh $DUT_IP

scp  -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no /home/muxpi/scripts/validation-NUC.sh root@$DUT_IP:/home	
ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no root@$DUT_IP "/home/validation-NUC.sh"
