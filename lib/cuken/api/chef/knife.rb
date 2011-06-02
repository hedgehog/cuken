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
require 'chef/application/knife'

module ::Cuken
  module Api
    module Chef
      module Knife

        include ::Cuken::Api::Common

        class CliTemplate
          include Mixlib::CLI
        end

        # Ripped from Grit: https://github.com/mojombo/grit

        class CommandTimeout < RuntimeError
          attr_accessor :command
          attr_accessor :bytes_read

          def initialize(command = nil, bytes_read = nil)
            @command = command
            @bytes_read = bytes_read
          end
        end

        # Raised when a command exits with non-zero.
        class CommandFailed < StandardError
          # The full command that failed as a String.
          attr_reader :command

          # The integer exit status.
          attr_reader :exitstatus

          # Everything output on the command's stderr as a String.
          attr_reader :err

          def initialize(command, exitstatus=nil, err='')
            if exitstatus
              @command = command
              @exitstatus = exitstatus
              @err = err
              message = "Command failed [#{exitstatus}]: #{command}"
              message << "\n\n" << err unless err.nil? || err.empty?
              super message
            else
              super command
            end
          end
        end


        def set_cli_options_template(data)
          conf = data[:config]||'/etc/chef/knife.rb'
          CliTemplate.option(:config_file, :long => '--config CONFIG', :default => conf)
          CliTemplate.option(:no_editor, :long => "--no-editor", :boolean => true, :default => true)
          CliTemplate.option(:yes, :long => "--yes", :boolean => true, :default => true)
        end

        def show_client(client_name)
          chef.client_private_key_path = chef.root_dir + "/.chef/#{client_name}.pem"
          data = {:name => client_name,
                  :config_file => chef.knife_config_file}
          argv = ['client', 'show', data[:name], '--config', data[:config_file],'--no-editor']
          argv << '--admin' if data[:admin]
          with_args *argv do
            ::Chef::Application::Knife.new.run
          end
        end

        def ensure_node_presence(node_name, expect_presence = true)
          nd = node_show(node_name)
          unless nd.class.to_s == 'Chef::Node' && nd.name == node_name
            node_create(node_name)
          end
          nd = node_show(node_name)
          nd.should be_an_instance_of(::Chef::Node)
          nd.name.should == node_name
        end

        def node_show(node_name, attr = :all)
          Pathname(chef.knife_config_file).exist?.should be_true
          argv = ['node', 'show', node_name, '--no-editor', '--config', chef.knife_config_file.to_s]
          unless attr == :all
            argv << '--attribute' << attr
          end
          if Pathname(chef.knife_config_file).exist?
            with_args *argv do
              ::Chef::Application::Knife.new.run
            end
          else
            # TODO: no config file error handling
          end
          ::Chef::Knife.cuken
        end

        def node_role_load(hsh)
          argv = ['node', 'run_list', 'add', hsh[:node], "role[#{hsh[:role]}]", '--no-editor', '--config', chef.knife_config_file.to_s]
          if Pathname(chef.knife_config_file).exist?
            with_args *argv do
              ::Chef::Application::Knife.new.run
            end
          else
            # TODO: no config file error handling
          end
          ::Chef::Knife.cuken
        end

        def node_create(node_name)
          argv = ['node', 'create', node_name, '--no-editor', '--config', chef.knife_config_file.to_s]
          if Pathname(chef.knife_config_file).exist?
            with_args *argv do
              ::Chef::Application::Knife.new.run
            end
          else
            # TODO: no config file error handling
          end
          ::Chef::Knife.cuken
        end

      end # class knife

    end # module Chef
  end # module Api
end # module Cuken

