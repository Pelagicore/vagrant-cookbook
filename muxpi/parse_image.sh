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
# Script downloads, unzips, compresses(tars)the nightly build depends on architecture and type (qt-auto, minimal),  
# copies .tar image to MuxPi. 
# Script executes on server. 
#
# Usage: 
# $ ./parse_image.sh ARCHVARIANT DUT_IP MUXPI_IP [neptune]
	# ARCHVARIANT: intel, rpi
	# DUT_IP: IP of DUT
	# MUXPI_IP:IP of MuxPi
	# neptune: optional, default minimal  
   
set -e
ARCHVARIANT="$1"
DUT_IP="$2"
MUXPI_IP="$3"
NEPTUNE_IMAGE="$4"

MUXPIPATH="$(pwd)/muxpi"
IMAGESPATH="$MUXPIPATH/images"

rm -rf $IMAGESPATH

VARIANT_MINIMAL="core-image-pelux-minimal-dev"
URL_MINIMAL="https://pelux.io/jenkins/job/pelux-manifests_NIGHTLY_$ARCHVARIANT-minimal/lastSuccessfulBuild/artifact/artifacts_$ARCHVARIANT/core-image-pelux-minimal-dev*/*zip*/artifacts_$ARCHVARIANT-minimal.zip"

VARIANT_NEPTUNE="core-image-pelux-qtauto-neptune-dev"
URL_NEPTUNE="https://pelux.io/jenkins/job/pelux-manifests_NIGHTLY_$ARCHVARIANT-qtauto/lastSuccessfulBuild/artifact/artifacts_$ARCHVARIANT-qtauto/core-image-pelux-qtauto-neptune-dev*/*zip*/artifacts-qtauto.zip"

VARIANT=""
URL=""
if [ "$NEPTUNE_IMAGE" == neptune ]; then
   VARIANT=$VARIANT_NEPTUNE
   URL=$URL_NEPTUNE
else
   VARIANT=$VARIANT_MINIMAL
   URL=$URL_MINIMAL
fi

if [ "$ARCHVARIANT" == "" ]; then
   echo "Please specify architecture. It can be 'intel' or 'rpi'"
   exit
fi

mkdir -p $MUXPIPATH
mkdir -p $IMAGESPATH
#------------------------------------------
echo "Downloading \"$VARIANT\"..."

wget $URL -P $IMAGESPATH 
if [ $? == 0 ]; then
   echo "Image downloaded"
fi

set +e
7z x $IMAGESPATH/*.zip -o$IMAGESPATH 
set -e

ls $IMAGESPATH
mv $IMAGESPATH/$VARIANT*rootfs* $IMAGESPATH/$VARIANT
echo "Compresing \"$VARIANT\"..."
(cd $IMAGESPATH; tar -czf $VARIANT.tar.gz $VARIANT)
if [ $? == 0 ]; then
   echo "Image has finished compressing"
fi

echo "{\"${VARIANT}\":\"\"}" > ./map.json
echo "Json map is ready"

echo "Flashing muxpi for \"$ARCHVARIANT\""

   scp -i ~/.ssh/build_slave_key $IMAGESPATH/$VARIANT.tar.gz muxpi@$MUXPI_IP:~/artifacts
   scp -i ~/.ssh/build_slave_key ./map.json muxpi@$MUXPI_IP:~/artifacts
   scp -i ~/.ssh/build_slave_key ./muxpi/ethup.sh muxpi@$MUXPI_IP:~/scripts
   scp -i ~/.ssh/build_slave_key ./muxpi/validation.sh muxpi@$MUXPI_IP:~/scripts

if [ "$ARCHVARIANT" == intel ]; then
   scp -i ~/.ssh/build_slave_key ./muxpi/nuc/flash_nuc.sh muxpi@$MUXPI_IP:~/scripts
   ssh -i ~/.ssh/build_slave_key muxpi@$MUXPI_IP "~/scripts/flash_nuc.sh $DUT_IP $VARIANT.tar.gz"
fi   

if [ "$ARCHVARIANT" == rpi ]; then
   scp -i ~/.ssh/build_slave_key ./muxpi/rpi/flash_rpi.sh muxpi@$MUXPI_IP:~/scripts
   ssh -i ~/.ssh/build_slave_key muxpi@$MUXPI_IP "~/scripts/flash_rpi.sh $DUT_IP $VARIANT.tar.gz"
fi   
