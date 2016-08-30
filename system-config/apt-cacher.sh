#!/bin/bash
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
    echo "hihihi"
    curl $server:$port > /dev/null 2>&1
    retval=$?
fi 

if [ "$retval" == "0" ] ; then 
    echo "Adding apt proxy to target" 
    echo -e "Acquire::http::Proxy \"http://$server:3142\";\n" > /etc/apt/apt.conf.d/80proxysettings
    apt-get update
else
    echo "Failed to set apt-proxy to $server"
fi
