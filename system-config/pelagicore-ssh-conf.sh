#!/bin/bash

echo "Adding git.pelagicore.net to the list of known hosts"

ssh-keyscan git.pelagicore.net | tee -a ~/.ssh/known_hosts
