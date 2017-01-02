# Copyright (c) 2013 Aidan Nagorcka-Smith
#
# MIT License
#
#Permission is hereby granted, free of charge, to any person obtaining
#a copy of this software and associated documentation files (the
#"Software"), to deal in the Software without restriction, including
#without limitation the rights to use, copy, modify, merge, publish,
#distribute, sublicense, and/or sell copies of the Software, and to
#permit persons to whom the Software is furnished to do so, subject to
#the following conditions:
#
#The above copyright notice and this permission notice shall be
#included in all copies or substantial portions of the Software.
#
#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
#EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
#MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
#NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
#LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
#OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
#WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#

begin
  require "vagrant"
rescue LoadError
  raise "The Vagrant Reload plugin must be run within Vagrant."
end

# This is a sanity check to make sure no one is attempting to install
# this into an early Vagrant version.
if Vagrant::VERSION < "1.2.0"
  raise "The Vagrant Reload plugin is only compatible with Vagrant 1.2+"
end

module VagrantPlugins
  module Reload

    VERSION = "0.0.1"

    class Plugin < Vagrant.plugin("2")
      name "Reload"
      description <<-DESC
      The reload plugin allows a VM to be reloaded as a provisioning step.
      DESC
      
      provisioner "reload" do
        class ReloadProvisioner < Vagrant.plugin("2", :provisioner)

          def initialize(machine, config)
            super
          end

          def configure(root_config)
          end

          def provision
            options = {}
            options[:provision_ignore_sentinel] = false
            @machine.action(:reload, options)
            begin
              sleep 10
            end until @machine.communicate.ready?
          end

          def cleanup
          end

        end
        ReloadProvisioner

      end
    end
  end
end

