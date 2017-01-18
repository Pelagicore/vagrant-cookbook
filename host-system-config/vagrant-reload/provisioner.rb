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

module VagrantPlugins
  module Reload

    class Provisioner < Vagrant.plugin("2", :provisioner)
      def provision

        # We support both a value and things like lambdas
        should_reload = false
        if config.condition.is_a?(Proc)
            # Evaluate this stored proc/lambda
            should_reload = config.condition.call
        else
            # Just copy the value
            should_reload = config.condition
        end

        # Ducktyping sucks, so we check if whatever we got equals to true.
        if true.equal?(should_reload)
            options = {}
            options[:provision_ignore_sentinel] = false
            @machine.action(:reload, options)
            begin
              sleep 10
            end until @machine.communicate.ready?
        end
      end
    end
  end
end

