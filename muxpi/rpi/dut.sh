#!/bin/bash
# Copyright (C) 2018 Luxoft Sweden AB
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
# This script runs the flashed image on RPI and verifies that the image 
# is running or degraded.  
# This script must be called from `set-up-image.sh` on muxpi. 
#
# Usage: 
# ./dut.sh 

set -e
rm -f $HOME/serial-output
echo "Setting up DUT" 

# Clear muxpi display and print 'DUT'

stm_armv7 -clr #clear display
stm_armv7 -print "DUT"

# Make the SD card adapter emulate a real SD-card. Note that the SD card wont be visible on muxpi when its on DUT mode.

stm_armv7 -dut
echo "RPI booting..."
sleep 35s
echo "Starting UART screens..."

stty -F /dev/ttyACM0 115200 cs8 -cstopb -parenb

# We need one screen to save the output of /dev/ttyACM0. Everything will be
# saved on 'serial-output'

screen -d -m -S output 
screen -S output -X stuff "cat /dev/ttyACM0 > ${HOME}/serial-output\n" 
sleep 3s

# This screen will be logging in the rpi and sending the commands to it.
# Note that when logging in, '\n' has to be passed multiple times as the 
# login might fail. 

screen -d -m -S input /dev/ttyACM0 115200 
screen -S input -X stuff '\nroot\n\n\n'
sleep 5s

# This returns either degraded or running. If it doesnt return either one, then
# something is wrong and rpi did not boot. This can be later grepped from
# `serial-output`

screen -S input -X stuff '\n\n\n systemctl is-system-running --wait\n'

sleep 5s

# Kill both of the screens as our job is done. 

screen -X -S input kill
screen -X -S output kill


sleep 5s

# Make the SD card visible on muxpi. (Opposite of stm_armv7 -dut)

stm_armv7 -ts #test server 

# Clear muxpi display and print 'Ready!'

stm_armv7 -clr #clear
stm_armv7 -print "Ready!"
stm_armv7 -dut
