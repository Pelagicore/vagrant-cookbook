#!/bin/bash

echo "Configuring the SSH client to use the correct user for gits at qt-project.org"

QT_PROJECT_USER=$1
if [ "$QT_PROJECT_USER" != "" ] ; then
mkdir -p ~/.ssh/
cat >> ~/.ssh/config <<-EOF
Host codereview.qt-project.org
    HostName codereview.qt-project.org
    Port 29418
    User $QT_PROJECT_USER
EOF
ssh-keyscan -p 29418 codereview.qt-project.org | tee -a ~/.ssh/known_hosts
fi
