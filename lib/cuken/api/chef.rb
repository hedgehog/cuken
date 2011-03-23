require 'aruba/api' unless defined? Aruba::Api
require 'chef'  unless defined? Chef
require 'cuken/api/chef/common'

module ::Cuken
  module Api
    module Chef

      include ::Cuken::Api::Chef::Common


        def rest
          @rest ||= ::Chef::REST.new('http://localhost:4000', nil, nil)
        end

        def tmpdir
          @tmpdir ||= ::File.join(Dir.tmpdir, "chef_integration")
        end

        def server_tmpdir
          @server_tmpdir ||= ::File.expand_path(File.join(datadir, "tmp"))
        end

        def datadir
          @datadir ||= ::File.join(File.dirname(__FILE__), "..", "data")
        end

        def configdir
          @configdir ||= ::File.join(File.dirname(__FILE__), "..", "data", "config")
        end

        def cleanup_files
          @cleanup_files ||= ::Array.new
        end

        def cleanup_dirs
          @cleanup_dirs ||= ::Array.new
        end

        def stash
          @stash ||= ::Hash.new
        end

        def gemserver
          @gemserver ||= ::WEBrick::HTTPServer.new(
            :Port         => 8000,
            :DocumentRoot => datadir + "/gems/",
            # Make WEBrick STFU
            :Logger       => ::Logger.new(StringIO.new),
            :AccessLog    => [ ::StringIO.new, ::WEBrick::AccessLog::COMMON_LOG_FORMAT ]
          )
        end

        attr_accessor :apt_server_thread

        def apt_server
          @apt_server ||= ::WEBrick::HTTPServer.new(
            :Port         => 9000,
            :DocumentRoot => datadir + "/apt/var/www/apt",
            # Make WEBrick STFU
            :Logger       => ::Logger.new(StringIO.new),
            :AccessLog    => [ ::StringIO.new, ::WEBrick::AccessLog::COMMON_LOG_FORMAT ]
          )
        end

        def admin_rest
          admin_client
          @admin_rest ||= ::Chef::REST.new(Chef::Config[:registration_url], 'bobo', "#{tmpdir}/bobo.pem")
        end

        def couchdb_rest_client
          ::Chef::REST.new('http://localhost:5984/chef_integration', false, false)
        end

    end
  end
end
