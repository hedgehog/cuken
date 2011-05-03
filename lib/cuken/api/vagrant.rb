#
# Author:: Hedgehog (<hedgehogshiatus@gmail.com>)
# Copyright:: Copyright (c) 2011 Hedgehog.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
require 'vagrant' unless defined? ::Vagrant

require 'cuken/api/common'
require 'cuken/api/vagrant/common'
require 'cuken/api/vagrant/v_m'

module ::Cuken
  module Api
    module Vagrant

      include ::Cuken::Api::Vagrant::Common

      class VVM
        include ::Cuken::Api::Vagrant::VM
      end

      def vagrant(box_name = nil)
        @vagrant ||= VVM.new(box_name)
      end

      def switch_vagrant_environment
        @vagrant = nil
      end

    end
  end
end

module ::Vagrant
  class SSH

    # In order to run Aruba's 'When I type "..."' steps:
    # Returns a Vagrant SSH connection string for the environment's virtual machine,
    # This method optionally takes a hash of options which override the configuration values.
    def ssh_connect_command(opts={})
      if Mario::Platform.windows?
        raise Errors::SSHUnavailableWindows, :key_path => env.config.ssh.private_key_path,
                                             :ssh_port => port(opts)
      end

      raise Errors::SSHUnavailable if !Kernel.system("which ssh > /dev/null 2>&1")

      options = {}
      options[:port] = port(opts)
      [:host, :username, :private_key_path].each do |param|
        options[param] = opts[param] || env.config.ssh.send(param)
      end

      check_key_permissions(options[:private_key_path])

      # Command line options
      command_options = ["-p #{options[:port]}", "-o UserKnownHostsFile=/dev/null",
                         "-o StrictHostKeyChecking=no", "-o IdentitiesOnly=yes",
                         "-i #{options[:private_key_path]}"]
      command_options << "-o ForwardAgent=yes" if env.config.ssh.forward_agent

      if env.config.ssh.forward_x11
        # Both are required so that no warnings are shown regarding X11
        command_options << "-o ForwardX11=yes"
        command_options << "-o ForwardX11Trusted=yes"
      end

      "ssh #{command_options.join(" ")} #{options[:username]}@#{options[:host]}".strip
    end

  end
end
