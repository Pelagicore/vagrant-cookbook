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
# This script runs the flashed image on NUC and verifies that the image 
# is running or degraded, displays what failed units and running services
# This script must be called from `flash.sh` on muxpi. 
#
# Usage: 
# ./validation-NUC.sh 

state=$(systemctl is-system-running --wait)
echo "$state"
if [ "$state" == running ]; then
   echo "System is running without failed services"
else  
   if [ "$state" == "degraded" ]; then
        systemctl --no-pager --failed > failed_units.txt
        systemctl list-units --type=service --state=running > running_service.txt
        echo "System os running but some sevices are failed, see failed_service.txt and running_service.txt"
        failed_list=$(grep failed failed_units.txt)
        echo "Failed services: $failed_list"
    else
        echo “Image failed to boot”
    fi 
 fi   
