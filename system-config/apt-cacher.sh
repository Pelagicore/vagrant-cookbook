#!/bin/bash

server=$1

ping -c1 $server
retval=$1

if [ "$retval" != "0" ] ; then 

    echo "Adding apt proxy to target" 

    echo -e "Acquire::http::Proxy \"http://$server:3142\";\n" > /etc/apt/apt.conf.d/80proxysettings

    apt-get update

else
    echo "Failed to set apt-proxy to $server"
fi
