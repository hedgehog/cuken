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

        def create_client(client_name)
          chef.client_private_key_path = chef.root_dir + "/.chef/#{client_name}.pem"
          data = {:name => client_name,
                  :admin => true,
                  :file => chef.client_private_key_path,
                  :no_editor => true,
                  :config_file => chef.knife_config_file}
          argv = ['client', 'create', data[:name], '--file', data[:file], '--config', data[:config_file],'--no-editor']
          argv << '--admin' if data[:admin]
          unless Pathname(chef.client_private_key_path).exist?
            with_args *argv do
              ::Chef::Application::Knife.new.run # (args, CliTemplate.options)
            end
          else
            #TODO: Verify client exists on the Chef server, and has matching public key.
          end
        end

        def show_client(client_name)
          chef.client_private_key_path = chef.root_dir + "/.chef/#{client_name}.pem"
          data = {:name => client_name,
                  :config_file => chef.knife_config_file}
          argv = ['client', 'show', data[:name], '--config', data[:config_file],'--no-editor']
          argv << '--admin' if data[:admin]
          with_args *argv do
            ::Chef::Application::Knife.new.run # (args, CliTemplate.options)
          end
        end

        def delete_client(client_name)
          chef.client_private_key_path = chef.root_dir + "/.chef/#{client_name}.pem"
          data = {:name => client_name,
                  :file => chef.client_private_key_path,
                  :no_editor => true,
                  :yes => true,
                  :print_after => true,
                  :config_file => chef.knife_config_file}
          argv = ['client', 'delete', data[:name], '--no-editor', '--yes' ]
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
          argv = ['node', 'show', node_name, '--no-editor', '--config', chef.knife_config_file]
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
          argv = ['node', 'run_list', 'add', hsh[:node], "role[#{hsh[:role]}]", '--no-editor', '--config', chef.knife_config_file]
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
          argv = ['node', 'create', node_name, '--no-editor', '--config', chef.knife_config_file]
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

