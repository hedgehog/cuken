module ::Cuken
  module Api
    module Chef
      module Common

        include ::Grit
        ::Grit.debug = true

        attr_accessor :recipe, :cookbook, :api_response, :inflated_response, :log_level,
                      :chef_args, :config_file, :stdout, :stderr, :status, :exception,
                      :gemserver_thread, :sandbox_url,
                      :uri, :client_private_key_path, :admin_client_name,
                      :client_name, :client_knife_path, :cookbook_paths, :cookbooks_paths,
                      :knife_debug, :local_cookbook_repo, :remote_cookbook_repo,
                      :local_chef_repo, :remote_chef_repo, :cookbooks_uri

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
          @remote_chef_repo ||= "git://github.com/opscode/chef-repo.git"
          @knife_debug = true if @knife_debug.nil?
          @cookbooks_paths ||= []
          @cookbook_paths ||= []
          @chef ||= self
        end

        def knife
          'knife '
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

      end
    end
  end
end
