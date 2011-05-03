module ::Cuken
  module Api
    module Chef
      module Common

        include ::Grit
        ::Grit.debug = true

        attr_accessor :admin_client_name,
                      :api_response,
                      :exception,
                      :chef_args,
                      :client_name,
                      :client_private_key_path,
                      :knife_config_file,
                      :cookbook,
                      :cookbook_paths,
                      :cookbooks_paths,
                      :cookbooks_uri,
                      :knife_debug,
                      :gemserver_thread,
                      :inflated_response,
                      :local_chef_repo,
                      :local_cookbook_repo,
                      :local_site_cookbook_repo,
                      :log_level,
                      :recipe,
                      :remote_chef_repo,
                      :remote_cookbook_repo,
                      :root_dir,
                      :sandbox_url,
                      :status,
                      :stderr,
                      :stdout,
                      :uri

        def self.ohai
          # ohai takes a while, so only ever run it once.
          @ohai ||= begin
            o = Ohai::System.new
            o.all_plugins
            o
          end
        end

        def ohai
          ::Cuken::Api::Chef::Common.ohai
        end

        def chef
          @remote_chef_repo ||= "git://github.com/cookbooks/chef-repo.git"
          @knife_debug = true if @knife_debug.nil?
          @cookbooks_paths ||= []
          @cookbook_paths ||= []
          @chef ||= self
        end

        def in_chef_root(&block)
          raise "You need to specify a Chef root directory." unless chef.root_dir
          ::Dir.chdir(chef.root_dir, &block)
        end

        def knife
          ::Cuken::Api::Chef::Knife.new
        end

        def knife_command
          'knife '
        end

        # TODO: Once a method is spec'd refactor to use this and knife_config_file_error_handling
        def run_knife(argv=[])
          argv << '--config' << chef.knife_config_file.to_s
          with_args *argv do
            ::Chef::Application::Knife.new.run
          end
          ::Chef::Knife.cuken
        end

        def knife_config_file_error_handling
          unless chef.knife_config_file && Pathname(chef.knife_config_file).exist?
            chef.knife_config_file = Pathname(chef.local_chef_repo).ascend { |d| h=d+'.chef'+'knife.rb'; break h if h.file? }
          end
          raise(RuntimeError, "chef.knife_config_file is required", caller) unless chef.knife_config_file
        end

        def knife_debug
          @knife_debug ||= true
        end

        def client
          @client ||= begin
            c = ::Chef::Client.new
            c.ohai = ohai
            c
          end
        end

        def root_dir
         @root_dir ||= Pathname.getwd
        end

        def knife_config_file
          @knife_config_file ||= (chef.root_dir + '/.chef/knife.rb')
        end

        def make_admin
          admin_client
          @rest = ::Chef::REST.new(Chef::Config[:registration_url], 'bobo', "#{tmpdir}/bobo.pem")
          #Chef::Config[:client_key] = "#{tmpdir}/bobo.pem"
          #Chef::Config[:node_name] = "bobo"
        end

        def make_non_admin
          r = ::Chef::REST.new(::Chef::Config[:registration_url], ::Chef::Config[:validation_client_name], ::Chef::Config[:validation_key])
          r.register("not_admin", "#{tmpdir}/not_admin.pem")
          c = ::Chef::ApiClient.cdb_load("not_admin")
          c.cdb_save
          @rest = ::Chef::REST.new(::Chef::Config[:registration_url], 'not_admin', "#{tmpdir}/not_admin.pem")
          #Chef::Config[:client_key] = "#{tmpdir}/not_admin.pem"
          #Chef::Config[:node_name] = "not_admin"
        end

        def admin_client
          unless @admin_client
            r = ::Chef::REST.new(::Chef::Config[:registration_url], ::Chef::Config[:validation_client_name], ::Chef::Config[:validation_key])
            r.register("bobo", "#{tmpdir}/bobo.pem")
            c = ::Chef::ApiClient.cdb_load("bobo")
            c.admin(true)
            c.cdb_save
            @admin_client = c
          end
        end

        def check_chef_root_presence(directory, expect_presence = true)
          chef.root_dir = directory
          check_placed_directory_presence([chef.root_dir], expect_presence)
        end

        def create_client(client_name, admin = false)
          chef.client_private_key_path = chef.root_dir + "/.chef/#{client_name}.pem"
          data = {:name => client_name,
                  :file => chef.client_private_key_path,
                  :no_editor => true,
                  :config_file => chef.knife_config_file}
          argv = ['client', 'create', data[:name], '--file', data[:file], '--config', data[:config_file],'--no-editor']
          argv << '--admin' if admin
          unless Pathname(chef.client_private_key_path).exist?
            with_args *argv do
              ::Chef::Application::Knife.new.run
            end
          else
            #TODO: Verify client exists on the Chef server, and has matching public key.
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

      end
    end
  end
end
