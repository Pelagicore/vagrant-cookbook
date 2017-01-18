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

#
# This plugin takes only one optional argument, "condition", which is either
# a bool, or something that should evaluate to a bool. If true, or missing,
# the reload step will be run. Otherwise, it won't be run.
#
module VagrantPlugins
  module Reload
    class Config < Vagrant.plugin("2", :config)
      attr_accessor :condition

      def initialize
        @condition = UNSET_VALUE
      end

      def finalize!
        # We set this to true if not set.
        @condition = true if @condition == UNSET_VALUE
      end
    end
  end
end
