require 'aruba/api' unless defined? Aruba::Api
require 'chef'  unless defined? Chef
require 'grit' unless defined? Grit
require 'vagrant' unless defined? Vagrant
require 'cuken/api/common'
require 'cuken/api/chef/common'
require 'cuken/api/chef/cookbook'
require 'cuken/api/chef/knife'

module ::Cuken
  module Api
    module Chef

      include ::Cuken::Api::Chef::Common

      def append_cookbook_path(cookbook, lp, lrp)
        if lrp.exist?
          announce_or_puts(%{Adding cookbook path: #{lp}}) if @announce_env && cookbook
          chef.cookbook_paths << lp if cookbook
          announce_or_puts(%{Adding cookbooks path: #{lp.parent}}) if @announce_env && cookbook
          chef.cookbooks_paths << lp.parent if cookbook
          lrp
        else
          announce_or_puts(%{WARNING: cookbook(s) path: #{lp} is not a Git repository.}) if @announce_env && cookbook
        end
      end


      def update_cookbook_paths(ckbk_path, cookbook)
        lp = Pathname(ckbk_path).expand_path.realdirpath
        lrp = lp + '.git'
        if cookbook
          append_cookbook_path(cookbook, lp, lrp)
        else
          lp.each_child do |pth|
            rpth = pth + '.git'
            append_cookbook_path(true, pth, rpth) if rpth.directory?
          end
          chef.cookbooks_paths.uniq!
          if chef.cookbooks_paths.empty?
            announce_or_puts(%{WARNING: cookbooks path: #{lp} does not contain any Git repositories.}) if @announce_env
          end
        end
      end

      def clone_pull_error_check(repo, res)
        if res[/Could not find Repository /]
          raise RuntimeError, "Could not find Cookbook in Repository #{repo}", caller
        end
      end

      def chef_clone_repo(ckbk_path, cookbook = false, repo = chef.remote_chef_repo, type = {'branch' => 'master'})
        in_current_dir do
          pth = Pathname(ckbk_path).expand_path
          gritty = ::Grit::Git.new(current_dir)
          announce_or_puts gritty.inspect
          clone_opts = {:quiet => false, :verbose => true, :progress => true}
          clone_opts[:branch] = type['branch'].empty? ? 'master' : type['branch']
          type['tag'] = type['tag'].nil? ? '' : type['tag']
          type['ref'] = type['ref'].nil? ? '' : type['ref']
          if pth.directory?
            announce_or_puts "Pulling: #{repo} into #{pth}"
            res = gritty.pull(clone_opts, repo, pth.to_s)
          else
            announce_or_puts "Cloning: #{repo} into #{pth}"
            res = gritty.clone(clone_opts, repo, pth.to_s)
          end
          clone_pull_error_check(repo, res) if res
          update_cookbook_paths(pth, cookbook)
          unless chef.cookbooks_paths.empty?   # is empty after cloning default chef-repo
            grotty = ::Grit::Git.new((pth + '.git').to_s)
            grotty.checkout( { :b => true }, clone_opts[:branch] )
            if !type['tag'].empty? || !type['ref'].empty?
              grotty.checkout( { :B => true }, 'cuken', type['tag']||type['ref'] )
            else
              grotty.checkout( { :B => true }, 'cuken' )
            end
          end
          pth
        end
      end

      def run_knife_command(cmd, interactive=false)
        no_ckbk_pth_opt = ['cookbook delete', 'role from file'].each{|str| break true if cmd[/#{str}/]}
        no_ckbk_pth = chef.cookbooks_paths.empty?
        if no_ckbk_pth
          ckbk_pth_opt = false
        else
          ckbk_pth = (chef.cookbooks_paths.collect { |pn| pn.expand_path.to_s }).join(':')
          ckbk_pth_opt = true
        end
        ckbk_pth_opt = false if no_ckbk_pth_opt.is_a? TrueClass
        in_current_dir do
          unless chef.knife_config_file
            chef.knife_config_file = Pathname(chef.local_chef_repo).ascend { |d| h=d+'.chef'+'knife.rb'; break h if h.file? }
          end
          raise(RuntimeError, "chef.knife_config_file is required", caller) unless chef.knife_config_file
        end
        cmd += " -c #{chef.knife_config_file.expand_path.to_s}" if chef.knife_config_file.expand_path.exist?
        cmd += " -o #{ckbk_pth}" if ckbk_pth_opt
        cmd += " --log_level debug" if chef.knife_debug
        chef.root_dir ||= current_dir
        in_chef_root do
          if interactive
            run_interactive(unescape("#{chef.knife_command}" + cmd))
          else
            run_simple(unescape("#{chef.knife_command}" + cmd))
          end
        end
      end

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
