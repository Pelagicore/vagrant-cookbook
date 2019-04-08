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
# $ ./parse_image.sh ARCHVARIANT DUT_IP [neptune]
	# ARCHVARIANT: intel, rpi
	# DUT_IP: IP of DUT
	# neptune: optional, default minimal 
   
set -e
ARCHVARIANT="$1"
DUT_IP="$2"
NEPTUNE_IMAGE="$3"

MUXPIPATH="$HOME/muxpi"
IMAGESPATH="$MUXPIPATH/images"

rm -rf $IMAGESPATH

VARIANT_MINIMAL="core-image-pelux-minimal-dev"
URL_MINIMAL="https://pelux.io/jenkins/job/pelux-manifests_NIGHTLY_intel-minimal/lastSuccessfulBuild/artifact/artifacts_intel/core-image-pelux-minimal-dev-intel*/*zip*/artifacts_intel-minimal.zip"

VARIANT_NEPTUNE="core-image-pelux-qtauto-neptune-dev"
URL_NEPTUNE="https://pelux.io/jenkins/job/pelux-manifests_NIGHTLY_intel-qtauto/lastSuccessfulBuild/artifact/artifacts_intel-qtauto/core-image-pelux-qtauto-neptune-dev-intel-corei7*/*zip*/artifacts-qtauto.zip"

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

wget --quiet $URL -P $IMAGESPATH 
if [ $? == 0 ]; then
   echo "Image downloaded"
fi

set +e
7z x $IMAGESPATH/*.zip -o$IMAGESPATH 
set -e

mv $IMAGESPATH/$VARIANT* $IMAGESPATH/$VARIANT

echo "Compresing \"$VARIANT\"..."
(cd $IMAGESPATH; tar -czf $VARIANT.tar.gz $VARIANT)
if [ $? == 0 ]; then
   echo "Image has finished compressing"
fi

echo "{\"${VARIANT}\":\"\"}" > $MUXPIPATH/map.json
echo "Json map is ready"

echo "Flashing muxpi for \"$ARCHVARIANT\""
if [ "$ARCHVARIANT" == intel ]; then
   scp -i ~/.ssh/build_slave_key $IMAGESPATH/$VARIANT.tar.gz muxpi@172.31.173.165:~/artifacts
   scp -i ~/.ssh/build_slave_key $MUXPIPATH/map.json muxpi@172.31.173.165:~/artifacts
   scp -i ~/.ssh/build_slave_key $MUXPIPATH/vagrant-cookbook/muxpi/nuc/flash.sh muxpi@172.31.173.165:~/scripts
   scp -i ~/.ssh/build_slave_key $MUXPIPATH/vagrant-cookbook/muxpi/nuc/ethup.sh muxpi@172.31.173.165:~/scripts
   scp -i ~/.ssh/build_slave_key $MUXPIPATH/vagrant-cookbook/muxpi/nuc/validation-NUC.sh muxpi@172.31.173.165:~/scripts
   ssh -i ~/.ssh/build_slave_key muxpi@172.31.173.165 "~/scripts/flash.sh $DUT_IP $VARIANT.tar.gz $NEPTUNE_IMAGE"
fi   
