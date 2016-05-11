#!/bin/bash

server=$1

ping -c1 $server
retval=$1

if [ "$retval" -ne "0" ] ; then 

    echo "Adding apt proxy to target" 

    echo -e "Acquire::http::Proxy \\"http://10.8.36.16:3142\\";\n" > /etc/apt/apt.conf.d/80proxysettings

    apt-get update

fi
