#!/bin/bash
# vagrant-cookbook
# Copyright © 2019 Luxoft Sweden AB
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
# Usage: build-testexport.sh <yoctodir> <images>
#
# Source the environment and build the supplied images in the yoctodir
#

YOCTO_DIR="$1"
IMAGES="$2"

echo "================================================================================================"
echo "BitBake'ing testexport for $IMAGES in $YOCTO_DIR"

# Set up bitbake environment
cd "$YOCTO_DIR"
source sources/poky/oe-init-build-env build

# A positive exit code from now on is fatal
set -e

# Start build
time bitbake -c testexport $IMAGES
