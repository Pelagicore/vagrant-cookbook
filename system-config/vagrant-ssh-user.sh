#!/bin/bash
#
# Usage: vagrant-ssh-user.sh <mail> <username>
#
# The script sets up the mail and username for git config.
#

echo "Setting up email and name for the vagrant build machine in git"

git config --global user.email "vagrant@pelagicore.com"
git config --global user.name "Vagrant automated build"
