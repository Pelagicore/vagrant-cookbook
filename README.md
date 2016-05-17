vagrant-cookbook
================

Introduction 
------------
The vagrant cookbook contains a lot of small code snippets that we can reuse in
Vagrantfiles provided for different projects. The general guideline is that the
snippets should be generic, and use parameters to create code reuse as far as
possible.

Example usage: Shell scripts
----------------------------
If you have a snippet of code that looks like this in your current Vagrantfile:

```ruby
config.vm.provision "shell", inline: <<-SHELL
    ping google.com &> /dev/null &
SHELL
```

It could be broken out into a `vagrant-cookbook/utils/keepalive.sh` script
containing the following code:

```bash
#!/bin/bash
ping google.com 6> /dev/null &
```

and then reference that code using:

```ruby
config.vm.provision "shell", path: "cookbook/utils/keepalive.sh"
```

Example usage: Vagrantfile fragments
------------------------------------
Snippets with the `.vagrantfile` suffix are fragments of a Vagrantfile, as
opposed to the shell scripts discussed above. These fragments are typically
executed on the host machine to do things like change VM parameters, etc. These
fragments are included using:

```ruby
eval File.read("path/to/tragment.vagrantfile")
```

Example usage in a project: As a git submodule
----------------------------------------------
In order for your project's Vagrantfile to gain access to the snippets in this
repository, you need to ensure this git is checked out and accessible to your
Vagrantfile. A good way to associate your project with a specific version of
the vagrant-cookbook repository is to use `git submodules` (for more info on
submodules, see here: https://git-scm.com/book/en/v2/Git-Tools-Submodules)

Use this git as a submodule in the following way:
```bash
cd your/project/
git submodule add <THIS REPOSITORY> vagrant-cookbook
```

Your Vagrantfile can now refer to the snippets as in the examples above.
