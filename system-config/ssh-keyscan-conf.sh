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
