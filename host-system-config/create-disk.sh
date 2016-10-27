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
# 
# Usage: create-disk.sh <disk>
# 
# This script will format the entire disk pointed to by <disk> with ext4 and 
# mount it as /home
# 
# This script is usually used in conjunction with the 
# attach-extra-disk.vagrantfile
#


disk=$1

echo "Formatting and mounting disk: $1"

# o  - clear the in memory partition table
# n  - new partition
# p  - primary partition
# 1  - partition number 1
#" " - default - start at beginning of disk
#" " - default - full disk
# w  - write the partition table
(echo o; echo n; echo p; echo 1; echo " "; echo " "; echo w;) | fdisk $disk
mkfs.ext4 ${disk}1

# Back up the old .ssh directory, this contains the pubkey for the
# vagrant tool, w/o this, we can't use "vagrant ssh"
cp -a /home/vagrant/.ssh /tmp

# Re-initialize the home directory
mount ${disk}1 /home

#Delete 
cp -r /etc/skel/ /home/vagrant

# Restore the .ssh backup
cp -a /tmp/.ssh /home/vagrant/

chown -R vagrant:vagrant /home/vagrant/
