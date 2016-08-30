#!/bin/bash
# 
# Usage: ssh-keyscan-conf.sh
# 
# Installs some commonly used ssh keys for git repositories used in builds.
#

echo "Adding git ssh keys to the list of known hosts"

ssh-keyscan git.pelagicore.net | tee -a ~/.ssh/known_hosts
ssh-keyscan github.com | tee -a ~/.ssh/known_hosts


echo "Adding git ssh keys and configuration for qt-project.org"

QT_PROJECT_USER=$1
if [ "$QT_PROJECT_USER" != "" ] ; then
    mkdir -p ~/.ssh/

    ssh-keyscan -p 29418 codereview.qt-project.org | tee -a ~/.ssh/known_hosts

    cat >> ~/.ssh/config <<-EOF
Host codereview.qt-project.org
    HostName codereview.qt-project.org
    Port 29418
    User $QT_PROJECT_USER
EOF
fi
