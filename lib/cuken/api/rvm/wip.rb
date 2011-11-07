#
# These methods have to be verified as working with RVM API - many were broken as of 1.6.5
#

module ::Cuken
  module Api
    module Rvm

      class RvmrcProcessor

        attr_writer :gemspecs_to_install

        def initialize(path)
          @root_path = ::File.directory?(path) ? path : File.dirname(path)
           rvmrc_read(path)
        end

        # read the .rvmrc file contents into @rvmrc
        def rvmrc_read(path)
          fn = ::File.directory?(path) ? path + '/.rvmrc' : path
          @rvmrc = ::File.new(fn).read
          return true if @rvmrc.size > 0
        end

        # return the .rvmrc file contents
        def rvmrc
          @rvmrc
        end

        # return ruby name parsed from .rvmrc file contents
        def rvmrc_ruby_name
          extract_rubie(rvmrc)
        end

        # return gemset name parsed from .rvmrc file contents
        def rvmrc_gemset_name
          extract_gemset(rvmrc)
        end

        # return concatenated string of rvmrc_ruby@rvmrc_gemset
        def rvmrc_ruby_gemset(rvmrc)
          "#{extract_rubie(rvmrc)}@#{extract_gemset(rvmrc)}"
        end

        # return an array of .rvmrc file paths found beneath a root folder
        def find_rvmrc_files(rvmrc_root)
          Dir.glob(rvmrc_root + '/**' + '/.rvmrc')
        end

        # return an arry of paths containing .rvmrc files
        def find_rvmrc_paths(rvmrc_root)
          root = File.directory?(rvmrc_root) ?  rvmrc_root : File.dirname(rvmrc_root)
          dirs = []
          find_rvmrc_files(root).each do |path|
            dirs << File.dirname(File.expand_path(path)) if File.file?(path)
          end
          dirs
        end

        #return an array of *.gems file paths found beneath a root folder
        def find_gems_files(rvmrc_root)
          Dir.glob(rvmrc_root + '/**' + '/*.gems')
        end

        # returns rubies and gemsets from .rvmrc files glob'ed below
        # a root folder.
        def all_rubies_gemsets(root_path=@root_path)
          @all_rubies_gemsets = Hash.new([])
          arry=find_rvmrc_paths(root_path)
          arry.each do |dir|
            Dir.glob(dir + '/*.gems').each do |fn|
              gsn     = File.basename(fn,'.gems').to_s
              rvmrc_read(dir + '/.rvmrc')
              rube    = rvmrc_ruby_name
              egsn    = rvmrc_gemset_name
              @all_rubies_gemsets[rube] = [] unless @all_rubies_gemsets.key? rube
              if gsn == egsn
                @all_rubies_gemsets[rube] << {:ruby_alias => "cuken_#{rube}",:gemset_alias => "cuken_#{gsn}", :gemset_name => gsn, :gemset_path => fn}
              end
            end
          end
          @all_rubies_gemsets
         end

        # returns hash of all gemsets, per-Ruby, in all .rvmrc files beneath a root folder
        def all_gemsets(root_path=@root_path)
          default = Hash.new{|hsh,ky| hsh[ky] = {:ruby_alias => "cuken_#{ky}"}}
          @all_rubies_gemsets ||= all_rubies_gemsets(root_path)
          @all_gemsets = @all_rubies_gemsets.inject(default){|h,(k,v)| h[k]; h[k][:gemsets]=v; h }
        end

        # returns array of all rubies in all .rvmrc files beneath a root folder
        def all_rubies(root_path=@root_path)
          @all_rubies_gemsets ||= all_rubies_gemsets(root_path)
          @all_rubies = @all_rubies_gemsets.keys
        end

        # yield a block in the environment of each in the installed rubies,
        # and return current Ruby string even if the given block raises
        def each_ruby
          begin
            all_rubies(@root_path).each do |rubie|
              RVM.use(rubie)
              yield rubie
            end
          rescue
          ensure
            RVM.reset_current!
          end
        end

        # create gemsets parsed from all .rvmrc files beneath a root folder
        def create_gemsets
          each_ruby do |rubie|
            all_gemsets(@root_path)[rubie][:gemsets].each do |hsh|
              ::RVM.gemset.create([hsh[:gemset_name]])
            end
          end
        end

        # Return array of [gem_name, gem_version] to be installed into all
        # gemsets found in .rvmrc files. Default is Bundler versio 1.0.10
        def gemspecs_to_install
          @gemspecs_to_install ||= [['bundler', '1.0.10']]
        end

      # Install @gemspecs_to_install contents using rubies and gemsets
      # found in .rvmrc files.
      def gems_install
        create_gemsets
        each_ruby do |rubie|
          gemspecs_to_install.each { |spec| install_gem(rubie, spec) }
        end
      end

      # return the options string for Ruby's `gem install...` CLI
      def gem_install_options
        @gem_install_options ||= ['no_ri', 'no_rdoc']
        "--" + @gem_install_options.join(' --')
      end

      # install given gem into all ruby+gemsets parsed from .rvmrc files beneath a root folder
      def install_gem(rubie, spec)
        gem, version = spec
        all_gemsets.each do |rubie, hsh|
          hsh[:gemsets].each do |h|
            if gem_available?(spec)
              puts "info: Gem #{gem}-#{version} already installed in #{rvm_current_name}."
            else
              puts "info: Installing gem #{gem}-#{version} in #{rvm_current_name}..."
              RVM.gemset.use(h[:gemset_alias])
              RVM.run("rvm --create use #{h[:gemset_alias]}; gem install #{gem} -v#{version} #{gem_install_options}")
            end
          end
        end
      end

      # return the parsed .rvmrc info for the current ruby
      def current_ruby_info(rubie)
        @all_rubies_gemsets ||= all_rubies_gemsets
        @all_rubies_gemsets[rubie]
      end

      def rvm_path
        pn = Pathname.new(File.expand_path(ENV['rvm_path'] || '~/.rvm'))
        pn.exist? ? pn : raise(RuntimeError, "Could not find RVM's .rvm folder (#{pn})", caller)
      end
      # Does not install existing RVM rubies that are listed in the .rvmrc files
      # raise an error if RVM's install root does not exist
      def setup_rubies
        rvm_loaded? ? true : raise(RuntimeError, "RVM library not loaded.", caller)
        @all_rubies_gemsets ||= all_rubies_gemsets(@root_path)
        @all_rubies_gemsets.keys.each do |rubie|
          if RVM.list_strings.include?(rubie)
            puts "info: Rubie #{rubie} already installed."
          else
            with_rvm_environment_vars do
              install_rubie(rubie)
            end
          end
          RVM.alias_create(current_ruby_info(rubie)[0][:ruby_alias], "#{rubie}") unless rubie == current_ruby_info(rubie)[0][:ruby_alias]
        end
      end

        private
          def extract_rubie(rvmrc)
            rvmrc[/ruby_id=\"(.*)\"/, 1]
          end
          def extract_gemset(rvmrc)
            rvmrc[/gemset_id=\"(.*)\"/, 1]
          end
          def gem_available?(spec)
            gem, version = spec
            RVM.ruby_eval("require 'rubygems' ; print Gem.available?('#{gem}','#{version}')").stdout == 'true'
          end
          def rvm_current_name
            RVM.current.expanded_name
          end

          def rvm_loaded?
            @rvm_setup = defined?(RVM) ? true : false
            return(true) if @rvm_setup
            rvm_lib_path = rvm_path + "lib" rescue return
            $LOAD_PATH.unshift(rvm_lib_path.to_s) unless $LOAD_PATH.include?(rvm_lib_path.to_s)
            require 'rvm'
            @rvm_setup = defined?(RVM) ? true : false
          end

          def install_rubie(rubie)
            std_msg = "info: Rubie #{rubie} installed."
            err_msg  = "Failed #{rubie} install! Check RVM logs here: #{RVM.path}/log/#{rubie}"
            puts "info: Rubie #{rubie} installation inprogress. This couldtake awhile..."
            RVM.install(rubie, rvm_install_options) ? puts(std_msg) : abort(err_msg)
          end

          def rvm_install_options
            { }
          end

          def with_rvm_environment_vars
            my_vars = rvm_environment_vars
            current_vars = my_vars.inject({}) { |cvars,kv| k,v = kv ; cvars[k]= ENV[k] ; cvars }
            set_environment_vars(my_vars)
            yield
            ensure
            set_environment_vars(current_vars)
          end

          def set_environment_vars(vars)
            vars.each { |k,v| ENV[k] = v }
          end

          def rvm_environment_vars
             if rvm_for_macports?
               {'CC' => '/usr/bin/gcc-4.2',
                'CFLAGS' => '-O2 -arch x86_64',
                'LDFLAGS' => '-L/opt/local/lib -arch x86_64',
                'CPPFLAGS' => '-I/opt/local/include'}
             else
               {}
             end
           end

           def rvm_for_macports?
             `uname`.strip == 'Darwin' && `which port`.present?
           end

      end # class RvmrcProcessor

      module_function
       class << self
         attr_accessor :rvm_install_rubies, :rvm_install_gem_specs,
           :rvm_gem_install_options
       end

      def run_simple_gemset(cmd_str, options = {} )
        # RVM 1.6.5 is not generating rvm-legal code when given a command str so we write to a temp file
        tmpfile = ::Tempfile.open("cuken_#{__method__.to_s}_"){ |f| f.puts(cmd_str);f }
        tmpfile.close
        Pathname(tmpfile).chmod(0700)
        FileUtils.copy(tmpfile,tmpfile.path+'.bak')
        @run_simple_gemset_result = nil
        begin
          case
            when options.key?(:ruby) && options.key?(:gemset)
              full_gemset_string = "#{options[:ruby]}@#{options[:gemset]}"
            when options.key?(:ruby) && !options.key?(:gemset)
              full_gemset_string = "#{options[:ruby]}@#{RVM.current.gemset.name}"
            when !options.key?(:ruby) && options.key?(:gemset)
              full_gemset_string = "#{RVM.current.expanded_name[/(.*)@/,1]}@#{options[:gemset]}"
            when !options.key?(:ruby) && !options.key?(:gemset)
              full_gemset_string = RVM.current.expanded_name
            else
              full_gemset_string = RVM.current.expanded_name
          end
          raise(::ArgumentError, "The RVM gemset #{full_gemset_string} is not present.") unless ::RVM.list_gemsets.include?(full_gemset_string)
          ::RVM.environment(full_gemset_string) do |env|
            if @announce_env
              announce_or_puts("Ruby environment for #{::RVM.current.expanded_name}:")
              announce_or_puts("#{env.info.inspect}")
            end
            @run_simple_gemset_result = env.ruby(tmpfile, options)
            #sin = @run_simple_gemset_result.command
            #sout = @run_simple_gemset_result.stdout
            #serr = @run_simple_gemset_result.stderr
            #estat = @run_simple_gemset_result.exit_status
          end
        rescue ::Exception => e
          puts e.message
          puts e.backtrace.join('\n')
          raise
        rescue ::ArgumentError => e
          puts "Exception raised by run_simple_gemset(#{cmd_str}, #{options})"
          puts "Script executed from #{tmpfile.to_s}:\n#{tmpfile.open.readlines}"
          puts "Exception: #{e.message}"
          puts e.backtrace.join('\n')
          raise e
        ensure
         tmpfile.unlink
        end
        @run_simple_gemset_result.inspect
      end

      def rvmrc(path)
         @rvmrc ||= RvmrcProcessor.new(path)
      end

      def rvm_current_name
        RVM.current.expanded_name
      end

      def rvm_gem_install_options
        @rvm_gem_install_options ||= ['no_ri', 'no_rdoc']
        "--" + @rvm_gem_install_options.join(' --')
      end

      def rvm_install_rubies
        @rvm_install_rubies ||= []
      end

      def rvm_install_gemspecs
        @rvm_install_gemspecs ||= [['bundler', '1.0.10']]
      end

      def rvm_create_gemsets
        @rvm_create_gemsets ||= []
      end

      def rvm_requested_gemset(gemset)
        @rvm_requested_gemset = gemset
      end

      def rvm_requested_gemset
        @rvm_requested_gemset ||='vagrant'
      end
      #wip
      def rvm_path
        pn = Pathname.new(File.expand_path(ENV['rvm_path'] || '~/.rvm'))
        pn.exist? ? pn : raise(RuntimeError, "Could not find RVM's .rvm folder (#{pn})", caller)
      end

      def rvm_local_install?
        rvm_path.dirname.realpath.directory?
      end
      # done
      def rvm_loaded?
        _rvm_load
      end

      def rvm_gemset_paths(root_path='/usr/src/cuken')
        rpn = Pathname(root_path)
        rvmrc_dirs = []
        Dir.glob((rpn + '**' + '.rvmrc').to_s).each do |d|
          dn = File.dirname(d)
          rvmrc_dirs << dn if File.directory?(dn)
        end
        rvmrc_dirs
      end

      # done
      def rvmrc_rubies_gemsets(root_path='/usr/src/cuken')
        @rvmrc_rubies_gemsets = Hash.new([])
        arry=rvm_gemset_paths(root_path)
        arry.each do |dir|
          Dir.glob(dir + '/*.gems').each do |fn|
            gsn     = File.basename(fn,'.gems').to_s
            rvmrc   = File.new(File.dirname(fn) + '/.rvmrc').read
            rube    = rvmrc_extract_ruby(rvmrc)
            egsn    = rvmrc_extract_gemset(rvmrc)
            @rvmrc_rubies_gemsets[rube] = [] unless @rvmrc_rubies_gemsets.key? rube
            @rvmrc_rubies_gemsets[rube] << gsn if gsn == egsn
          end
        end
        @rvmrc_rubies_gemsets
       end
      # done
      def rvmrc_rubies
        @rvmrc_rubies ||= _rvmrc_rubies #.keys.map{ |rubie| "#{rubie}@#{rvm_requested_gemset}" }
      end
      #wip
      def rvm_rubies_setup(root_path='/usr/src/cuken')
        rvm_loaded? ? true : raise(RuntimeError, "RVM library not loaded.", caller)
        @rvmrc_rubies_gemsets ? true : rvmrc_rubies_gemsets(root_path)
        @rvmrc_rubies_gemsets.keys.each do |rubie|
          if RVM.list_strings.include?(rubie)
            puts "info: Rubie #{rubie} already installed."
          else
            with_rvm_environment_vars do
              _rvm_install_rubie(rubie)
            end
          end
          RVM.alias_create(rvmrc_rubies[rubie][:alias], "#{rubie}@#{rvm_requested_gemset}") unless rubie == rvmrc_rubies[rubie][:alias]
        end
      end
      #done
      def rvm_current_rubie_info
        rvmrc_rubies[_rvm_current_rubie_name]
      end

      # Install @rvm_install_gemspecs gemspec using rubies and gemsets
      # found in .rvmrc files.
      # done
      def rvmrc_gems_install(root_path)
        @rvmrc_root_path = root_path
        _rvmrc_create_gemsets
        _each_rvmrc_rubie do |rubie|
          rvm_install_gemspecs.each { |spec| _rvmrc_install_gem(rubie, spec) }
        end
      end

      def rvmrc_gemsets_install(root_path)
        @rvmrc_root_path = root_path
        _each_rvmrc_rubie do |rubie|
          rvm_install_gemspecs.each { |spec| _rvmrc_install_gem(rubie, spec) }
        end
      end

      protected
      #done
      def _rvm_load
        @rvm_setup = false
        rvm_lib_path = rvm_path + "lib" rescue return
        $LOAD_PATH.unshift(rvm_lib_path.to_s) unless $LOAD_PATH.include?(rvm_lib_path.to_s)
        require 'rvm'
        @rvm_setup = defined?(RVM) ? true : false
      end
      module_function :_rvm_load
      #done
      def _rvm_install_rubie(rubie)
        std_msg = "info: Rubie #{rubie} installed."
        err_msg  = "Failed #{rubie} install! Check RVM logs here: #{RVM.path}/log/#{rubie}"
        puts "info: Rubie #{rubie} installation inprogress. This couldtake awhile..."
        RVM.install(rubie, rvm_install_options) ? puts(std_msg) : abort(err_msg)
      end
      module_function :_rvm_install_rubie

      #done
      def rvmrc_extract_ruby_gemset(rvmrc)
        "#{rvmrc_extract_ruby(rvmrc)}@#{rvmrc_extract_gemset(rvmrc)}"
      end
      module_function :rvmrc_extract_ruby_gemset
      #done
      def rvmrc_extract_ruby(rvmrc)
        rvmrc[/ruby_id=\"(.*)\"/, 1]
      end
      module_function :rvmrc_extract_ruby
      #done
      def rvmrc_extract_gemset(rvmrc)
        rvmrc[/gemset_id=\"(.*)\"/, 1]
      end
      module_function :rvmrc_extract_gemset
      #done
      def _rvmrc_rubies
        default = Hash.new{|hsh,ky| hsh[ky] = {:alias => "cuken-#{ky}"}}
        @rvmrc_rubies_gemsets ||= rvmrc_rubies_gemsets(@rvmrc_root_path)
        @rvmrc_rubies = @rvmrc_rubies_gemsets.keys.inject(default){|h,(k,v)| h[k]; h }
      end
      module_function :_rvmrc_rubies
      #done
      def _rvmrc_gemsets
        default = Hash.new{|hsh,ky| hsh[ky] = {:alias => "cuken-#{ky}"}}
        @rvmrc_rubies_gemsets ||= rvmrc_rubies_gemsets(@rvmrc_root_path)
        @rvmrc_gemsets = @rvmrc_rubies_gemsets.inject(default){|h,(k,v)| h[k]; h[k][:gemsets]=v; h }
      end
      module_function :_rvmrc_gemsets
      # done
      def _each_rvmrc_rubie
        _rvmrc_rubies.each do |ary|
          RVM.use(ary[0])
          yield ary[0]
        end
      ensure
        RVM.reset_current!
      end
      module_function :_each_rvmrc_rubie
      # done
      def _rvmrc_create_gemsets
        _rvmrc_gemsets.each do |hsh|
          RVM.use hsh[0]
          hsh[1][:gemsets].each do |gmst|
            # TODO: Post refactor
            #RVM.gemset.create([gmst])
          end
        end
      end
      module_function :_rvmrc_create_gemsets
      #done
      def _rvmrc_install_gem(rubie, spec)
        gem, version = spec
        _rvmrc_gemsets.each do |hsh|
          rubie = hsh[0]
          hsh[1][:gemsets].each do |gmst|
            if RVM.gemset.instance_of? ::RVM::Environment::GemsetWrapper
              #RVM.gemset.create([gmst])
              RVM.gemset.use(gmst)
              if _rvm_gem_available?(spec)
                puts "info: Gem #{gem}-#{version} already installed in #{rvm_current_name}."
              else
                puts "info: Installing gem #{gem}-#{version} in #{rvm_current_name}..."
                RVM.run("rvm --create use #{rubie}@#{gmst}; gem install #{gem} -v#{version} #{rvm_gem_install_options}")
              end
            end
          end
        end
      end
      module_function :_rvmrc_install_gem

      # done
      def set_environment_vars(vars)
        vars.each { |k,v| ENV[k] = v }
      end
      module_function :set_environment_vars
      #done
      def with_rvm_environment_vars
        my_vars = rvm_environment_vars
        puts my_vars
        current_vars = my_vars.inject({}) { |cvars,kv| k,v = kv ; cvars[k]= ENV[k] ; cvars }
        puts current_vars
        set_environment_vars(my_vars)
        yield
        ensure
        set_environment_vars(current_vars)
      end
      module_function :with_rvm_environment_vars
      #done
      def rvm_environment_vars
         if rvm_for_macports?
           {'CC' => '/usr/bin/gcc-4.2',
            'CFLAGS' => '-O2 -arch x86_64',
            'LDFLAGS' => '-L/opt/local/lib -arch x86_64',
            'CPPFLAGS' => '-I/opt/local/include'}
         else
           {}
         end
       end
       module_function :rvm_environment_vars
       #done
       def rvm_for_macports?
         `uname`.strip == 'Darwin' && `which port`.present?
       end
       module_function :rvm_for_macports?
       # done
       def rvm_install_options
         { }
       end
       module_function :rvm_install_options
      #done
      def _rvm_gem_available?(spec)
        gem, version = spec
        RVM.ruby_eval("require 'rubygems' ; print Gem.available?('#{gem}','#{version}')").stdout == 'true'
      end
      module_function :_rvm_gem_available?
    end
  end
end
