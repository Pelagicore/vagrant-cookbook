#!/bin/bash

# Copyright (C) 2018 Luxoft Sweden AB
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
# This script downloads, flashes the image and tests it on RPI. 
# This script must be run on muxpi.
#
# Usage: 
# $ ./set-up-image.sh [neptune]
# The default image to use is the minimal image. If you want to run the neptune image
# use the option 'neptune'.
#

set -e


NEPTUNE_IMAGE="$1"
IMAGES="$HOME/images"

# The url for the latest successful nightly build.

VARIANT_MINIMAL="core-image-pelux-minimal-dev"
URL_MINIMAL="https://pelux.io/jenkins/job/pelux-manifests_NIGHTLY/lastSuccessfulBuild/artifact/artifacts_rpi/$VARIANT_MINIMAL*/*zip*/artifacts_rpi.zip"

VARIANT_NEPTUNE="core-image-pelux-qtauto-neptune-dev"
URL_NEPTUNE="https://pelux.io/jenkins/job/pelux-manifests_NIGHTLY/lastSuccessfulBuild/artifact/artifacts_rpi-qtauto/$VARIANT_NEPTUNE*/*zip*/artifacts_rpi-qtauto.zip"

VARIANT=""
URL=""
if [ "$NEPTUNE_IMAGE" == neptune ]; then
   VARIANT=$VARIANT_NEPTUNE
   URL=$URL_NEPTUNE
else 
   VARIANT=$VARIANT_MINIMAL
   URL=$URL_MINIMAL
fi

mkdir -p $IMAGES

wget $URL -P $IMAGES
if [ $? == 0 ]; then
   echo "Image downloaded"
fi
7z x $IMAGES/*.zip -o$IMAGES
mv $IMAGES/$VARIANT* $IMAGES/$VARIANT

# map.json requires the image names and the number of the partition on SD-card.
# In our case, we dont need partition numbers, we want the image to be flashed
# on /dev/sda directly.

echo "{\"${VARIANT}\":\"\"}" > $HOME/map.json
echo "Json map is ready. Compressing the downloaded image... "
   
(cd $IMAGES; tar -czf $VARIANT.tar.gz $VARIANT)
if [ $? == 0 ]; then
   echo "Image has finished compressing" 
fi

# fota requires the card device to be flashed, the json map which contains
# the image and partitions, and finally the compressed image on tar.gz

fota_armv7 -card /dev/sda -map $HOME/map.json $IMAGES/$VARIANT.tar.gz 
if [ $? == 0 ];then
   echo "Image '${VARIANT}' successfully flashed using fota"
fi


echo "Image is set up. Booting up RPI ..."

COUNTER=5
C=0
set +e

# When the rpi boots, the login page can behave different 
# from time to time (serial communication might be a reason).
# This requires multiple attempts of logging in and sending a message.

while [ $C -lt $COUNTER ]; do
   let C+=1   
   echo "Attempt number:" $C " out of " $COUNTER
   $HOME/scripts/dut.sh
   grep -r "running" $HOME/serial-output | grep -v is-system-running
   if [ $? == 0 ]; then
      echo "Image is successfully running"
      rm -rf $IMAGES
      break
   else
      grep -r "degraded" $HOME/serial-output
      if [ $? == 0 ]; then
         echo "Image is running, but some packages have failed. System status:
         degraded"
         rm -rf $IMAGES
         break
      else
         echo "Image booting has failed"
         echo "--------------------"
         if [ $(( $C + 1 )) -gt $COUNTER  ]; then
            set -e 
            rm -rf $IMAGES
            exit 1
         fi	    
    fi
fi						       
done	
