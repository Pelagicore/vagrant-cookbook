# Copyright (c) 2013 Aidan Nagorcka-Smith
# Copyright (c) 2017 Pelagicore AB
#
# MIT License
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#

require "vagrant"

module VagrantPlugins
  module Reload
    class Plugin < Vagrant.plugin("2")
      name "reload"
      description <<-DESC
      The reload plugin allows a VM to be reloaded as a provisioning step.
      It allows for passing a condition to it, which is useful if one wants
      only reload the first time one provisions
      DESC

      config(:reload, :provisioner) do
        require File.expand_path("../config", __FILE__)
        Config
      end

      provisioner(:reload) do
        require File.expand_path("../provisioner", __FILE__)
        Provisioner
      end
    end
  end
end
