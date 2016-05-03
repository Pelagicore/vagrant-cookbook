#!/bin/bash

# On some hosts, the network stack needs to be kicked alive
ping google.com &> /dev/null &
