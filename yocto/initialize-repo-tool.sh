#!/bin/bash

echo "Downloading and setting up the repo tool"

sudo apt-get install -y curl

mkdir -p ~/bin/
echo "export PATH=~/bin/:$PATH" >> ~/.bashrc
curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
chmod a+x ~/bin/repo
