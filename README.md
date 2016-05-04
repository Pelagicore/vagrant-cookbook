vagrant-cookbook
================

Introduction 
------------
The vagrant cookbook contains a lot of minor code snippets that we can reuse in
Vagrantfiles provided for different projects. The general guideline is that the
snippets should be generic, and use parameters to create code reuse as far as
possible.

Example usage
-------------
If you have a snippet of code that looks like this in your current Vagrantfile:

config.vm.provision "shell", inline: <<-SHELL
        ping google.com &> /dev/null &
SHELL

It could be broken out into a vagrant-cookbook/utils/keepalive.sh script
containing the following code:

#!/bin/bash
ping google.com 6> /dev/null &

and then reference that code using:

config.vm.provision "shell", path: "cookbook/utils/keepalive.sh"
