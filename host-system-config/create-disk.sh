#!/bin/bash

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
