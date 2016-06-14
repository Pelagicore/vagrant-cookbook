#!/bin/bash

server=$1
port=3142

curl $server:$port > /dev/null 2>&1
retval=$1

if [ "$retval" != "0" ] ; then 
    echo "Adding apt proxy to target" 
    echo -e "Acquire::http::Proxy \"http://$server:3142\";\n" > /etc/apt/apt.conf.d/80proxysettings
    apt-get update
else
    echo "Failed to set apt-proxy to $server"
fi
