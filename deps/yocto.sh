#!/bin/bash
# Install dependencies needed to run BitBake

sudo apt-get update
sudo apt-get install -y git sed wget cvs subversion git-core            \
    coreutils unzip gawk python-pysqlite2 diffstat help2man make gcc    \
    build-essential g++ chrpath libxml2-utils libsdl1.2-dev texinfo

