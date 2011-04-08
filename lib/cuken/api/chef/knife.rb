
module ::Cuken
  module Api
    module Chef
      class Knife


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

          # Methods not defined by a library implementation execute the git command
          # using #native, passing the method name as the git command name.
          #
          # Examples:
          #   git.rev_list({:max_count => 10, :header => true}, "master")
#          def method_missing(cmd, options={}, *args, &block)
#            native(cmd, options, *args, &block)
#          end
        class RakeCLI
          include Mixlib::CLI
        end

        def create_client(data)
          ::Chef::Config[:node_name]  = data[:node_name]
          @knife = ::Chef::Knife::Configure.new
          #@knife = ::Chef::Knife::ClientCreate.new
          @knife.config[:no_editor]=data[:no_editor]
          @knife.config[:file]=data[:file]
          @knife.config[:admin]=data[:admin]
          @knife.name_args << data[:name]
          @knife.config[:config_file]='/etc/chef/knife.rb'
          @cli = RakeCLI.new
          #parsed_data = @knife.parse_options ['-f', data[:file], '-a' ]
          #parsed_data2 = @knife.opt_parser
          data = {:name => 'Im_new_here',
                :admin => 'true',
                :node_name => 'chef.kitchen.org',
                :file => '/some/sekret.pem',
                :no_editor => 'true'}
#          opts=RakeCLI.option(:config_file,'/etc/chef/knife.rb')
#          RakeCLI.option(:admin, data[:admin] )
#          RakeCLI.option(:file, data[:file])
#          RakeCLI.option(:no_editor, data[:admin])
#          RakeCLI.option(:node_name, data[:node_name])
          #RakeCLI.options
          ::Chef::Knife.run(['client', 'create'],@knife.options)
        end

        def delete_client(data)

        end

      end # class knife

    end # module Chef
  end # module Api
end #module Cuken

