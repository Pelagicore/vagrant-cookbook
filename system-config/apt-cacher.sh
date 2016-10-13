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
# Usage: apt-cacher.sh <server>
# 
# Setup an apt-cacher server with the host system, used to improve download 
# speeds of apt repositories. 
#


server=$1
port=3142

retval=1
ping -c 1 $server
pingretval=$?
if [ $pingretval == 0 ] ; then 
    curl $server:$port > /dev/null 2>&1
    retval=$?
fi 

if [ "$retval" == "0" ] ; then 
    echo "Adding apt proxy to target" 
    echo -e "Acquire::http::Proxy \"http://$server:3142\";\n" > /etc/apt/apt.conf.d/80proxysettings
else
    echo "Failed to set apt-proxy to $server"
fi

apt-get update
