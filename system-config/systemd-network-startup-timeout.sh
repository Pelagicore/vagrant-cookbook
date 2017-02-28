#!/bin/bash
# vagrant-cookbook
# Copyright (C) 2016 Pelagicore AB
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
# Usage: systemd-network-startup-timeout.sh
#
# Shortens the network startup timeout on systemd networking service from 5
# minutes to 1 minute.
#
# Note: Needs to be run as root
#

echo "Setting timeout of network startup to 1 minute"

sed -i 's/TimeoutStartSec=5min/TimeoutStartSec=1min/' \
    /etc/systemd/system/network-online.target.wants/networking.service

systemctl daemon-reload
