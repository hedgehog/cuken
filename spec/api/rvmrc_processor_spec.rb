require Pathname(__FILE__).ascend { |d| h=d+'spec_helper.rb'; break h if h.file? }


module ::Cuken::Api::Rvm
  describe RvmrcProcessor do
    before(:all) do
      ::FakeFS.activate!
      ::FakeFS::FileSystem.clear
      @rvmrc_root = setup_rvmrc_gems_files(1)
      @rvmrc_file = Dir.glob(@rvmrc_root + '/**' + '/.rvmrc')[-1]
    end
    before(:each) do
      @rvmrc_processor= ::Cuken::Api::Rvm::RvmrcProcessor.new(@rvmrc_file)
    end
    after(:all) do
      ::FakeFS.deactivate!
    end
    describe "#rvmrc_read"  do
      context "given the path to a .rvmrc file"  do
        it "should return the file contents" do
          rvmrc_contents = @rvmrc_processor.rvmrc_read(@rvmrc_file)
          rvmrc_contents.should be_true
        end
      end
      context "given the path to folder with a .rvmrc file"  do
        it "should read the file contents and return true on success" do
          rvmrc_contents = @rvmrc_processor.rvmrc_read(File.dirname(@rvmrc_file))
          rvmrc_contents.should be_true
        end
        describe "#rvmrc" do
          it "should return the contents of the .rvmrc file" do
            @rvmrc_processor.rvmrc_read(@rvmrc_file)
            @rvmrc_processor.rvmrc.size.should == 544
          end
        end
      end
    end

    context "having read the .rvmrc file" do
      before(:all) do
        @rvmrc_processor = ::Cuken::Api::Rvm::RvmrcProcessor.new(@rvmrc_file)
      end
      describe "#rvmrc_ruby_name" do
        it "should return the rubie name from the .rvmrc file" do
          @rvmrc_processor.rvmrc_ruby_name.should == "ruby-1.9.2-p136"
        end
      end
      describe "#rvmrc_gemset_name" do
        it "should return the gemset name from the .rvmrc file" do
          @rvmrc_processor.rvmrc_gemset_name.should == "1"
        end
      end
      describe "#find_rvmrc_files" do
        it "should return an array of .rvmrc file paths found beneath a root folder" do
          @rvmrc_processor.find_rvmrc_files(@rvmrc_root).should == ["/path/to/dir/.rvmrc", "/path/to/dir/1/.rvmrc"]
        end
      end
      describe "#find_rvmrc_paths" do
        context "when given a folder path" do
          it "should return an array of paths to .rvmrc files found beneath a root folder" do
            @rvmrc_processor.find_rvmrc_paths(@rvmrc_root).should == ["/path/to/dir", "/path/to/dir/1"]
          end
        end
        context "when given a file path" do
          it "should return an array of paths to .rvmrc files found beneath a root folder" do
            @rvmrc_processor.find_rvmrc_paths(@rvmrc_root+'/.rvmrc').should == ["/path/to/dir", "/path/to/dir/1"]
          end
        end
      end
      describe "#find_gems_files" do
        it "should return an array of *.gems file paths found beneath a root folder" do
          @rvmrc_processor.find_gems_files(@rvmrc_root).should == ["/path/to/dir/1/1.gems", "/path/to/dir/dir.gems"]
        end
      end
      describe "#all_rubies_gemsets" do
        context "when passed a folder path" do
         it "should return a hash whose keys are rubies (in the .rvmrc files)" do
           @rvmrc_processor.all_rubies_gemsets(@rvmrc_root).should be_kind_of(Hash)
           @rvmrc_processor.all_rubies_gemsets(@rvmrc_root).keys.each {|k| k.should match /ruby/ }
         end
         it "should return a hash whose values are array of gemsets (in the .rvmrc files)" do
           @rvmrc_processor.all_rubies_gemsets(@rvmrc_root).each do |k, v|
             k.should match /ruby/
             v.should be_kind_of(Array)
             v.each do |elem|
               elem.keys.should == [:ruby_alias, :gemset_alias, :gemset_name,:gemset_path]
             end
           end
         end
         it "should return RVM gemsets names that exist in the .rvmrc files" do
           root_path = setup_rvmrc_gems_files(8)
           res = @rvmrc_processor.all_rubies_gemsets(root_path)
           res.should have(1).item
           res.first.last.should have(9).items
           res.first.last[0].keys.should == [:ruby_alias, :gemset_alias, :gemset_name, :gemset_path]
         end
        end
        context "when not passed a folder path it uses the path passed to new and" do
         it "should return a hash whose keys are rubies (in the .rvmrc files)" do
           @rvmrc_processor.all_rubies_gemsets.should be_kind_of(Hash)
           @rvmrc_processor.all_rubies_gemsets.keys.each {|k| k.should match /ruby/ }
         end
         it "should return a hash whose values are array of gemsets (in the .rvmrc files)" do
           @rvmrc_processor.all_rubies_gemsets.each do |k, v|
             k.should match /ruby/
             v.should be_kind_of(Array)
             v.each do |elem|
               elem.keys.should == [:ruby_alias, :gemset_alias, :gemset_name,:gemset_path]
             end
           end
         end
         it "should return RVM gemsets names that exist in the .rvmrc files" do
           res = @rvmrc_processor.all_rubies_gemsets
           res.should have(1).item
           res.first.last.should have(8).items
           res.first.last[0].keys.should == [:ruby_alias, :gemset_alias, :gemset_name, :gemset_path]
         end
        end
      end
      describe "#all_gemsets" do
        context "when passed a folder path" do
          it "should return an Hash" do
            @rvmrc_processor.all_gemsets(@rvmrc_root).should be_kind_of Hash
          end
          it "should use as keys the rubies found in .rvmrc files beneath a root folder" do
            @rvmrc_processor.all_gemsets(@rvmrc_root).keys.should == ["ruby-1.9.2-p136"]
          end
          it "should return the alias and gemsets per ruby found in .rvmrc files beneath a root folder" do
            @rvmrc_processor.all_gemsets(@rvmrc_root)["ruby-1.9.2-p136"].keys.should == [:ruby_alias, :gemsets]
          end
        end
        context "when not passed a folder path" do
          it "should return an Hash" do
            @rvmrc_processor.all_gemsets.should be_kind_of Hash
          end
          it "should use as keys the rubies found in .rvmrc files beneath a root folder" do
            @rvmrc_processor.all_gemsets.keys.should == ["ruby-1.9.2-p136"]
          end
          it "should return the alias and gemsets per ruby found in .rvmrc files beneath a root folder" do
            @rvmrc_processor.all_gemsets["ruby-1.9.2-p136"].keys.should == [:ruby_alias, :gemsets]
          end
        end
      end
      describe "#all_rubies" do
        it "should return an Array" do
          @rvmrc_processor.all_rubies(@rvmrc_root).should be_kind_of Array
        end
        it "should return the rubies found in .rvmrc files beneath a root folder" do
          @rvmrc_processor.all_rubies(@rvmrc_root).should == ["ruby-1.9.2-p136"]
        end
      end
      describe "#each_ruby" do
        it "should use each of the installed rubies" do
          @rvmrc_processor.all_rubies(@rvmrc_root).each do |rubie|
            mock(::RVM).use.with(rubie).times(1){true}.should be_true
          end
          @rvmrc_processor.each_ruby do |rubie|
            true
          end
        end
        it "should yield a block in the environment of each in the installed rubies" do
          @rvmrc_processor.all_rubies(@rvmrc_root).each do |rubie|
            mock(::RVM).use.with(rubie).times(1){true}.should be_true
              return_value = @rvmrc_processor.each_ruby do |rubie|
              raise unless match /ruby/
              end
            return_value.should==[rubie]
          end
        end
         it "should return current Ruby string even if the given block raises in the environment of each in the installed rubies" do
          @rvmrc_processor.all_rubies(@rvmrc_root).each do |rubie|
            mock(::RVM).use.with(rubie).times(1){true}.should be_true
            lambda {
            return_value = @rvmrc_processor.each_ruby do |rubie|
              raise if match /ruby/
            end
            return_value.should==[rubie]
            }.should_not raise_error RuntimeError

          end
        end
      end
      describe "#create_gemsets" do
        it "should create gemsets parsed from all .rvmrc files beneath a root folder" do
          mock(::RVM).use.with(is_a(String)).times(1){true}
          mock(::RVM).gemset.times(8).stub!.create.with(is_a(Array)).times(8){true}
          @rvmrc_processor.create_gemsets
        end
      end

      describe "gemspecs_to_install" do
        it "should always install Bundler 1.0.10" do
          @rvmrc_processor.gemspecs_to_install == [["bundler", "1.0.10"]]
        end
        it "should return an array of 2-element arrays with gem name and version" do
          @rvmrc_processor.gemspecs_to_install << ['gem_a', '1.0.0']
          @rvmrc_processor.gemspecs_to_install << ['gem_b', '2.0.0']
          @rvmrc_processor.gemspecs_to_install == [["bundler", "1.0.10"], ["gem_a", "1.0.0"], ["gem_b", "2.0.0"]]
        end
      end

      # Some subtle issue with this spec it fails whenthe whole file is run,
      # but passes when run in isolation.
      describe "#gems_install" do
        it "should install gems from install_gemspecs_list into gemsets parsed from all .rvmrc files beneath a root folder" do
          stub(@rvmrc_processor).install_gem.with(is_a(String),is_a(Array)).times(1){true}
          @rvmrc_processor.gems_install
        end
      end
      describe "#gem_install_options" do
        it "should return the options string for Ruby's `gem install...` CLI" do
          @rvmrc_processor.gem_install_options.should == "--no_ri --no_rdoc"
        end
      end
      # Some subtle issue with this spec it fails whenthe whole file is run,
      # but passes when run in isolation.
      describe "#install_gem(rubie, spec)" do
        context "when the gem is not installed" do
          # Some subtle issue with this spec it fails whenthe whole file is run,
          # but passes when run in isolation.
          it "should install given gem into all ruby+gemsets parsed from .rvmrc files beneath a root folder" do
            #mock(::RVM).use.with(is_a(String)).times(1){true}
            stub(@rvmrc_processor).gem_available?.with(is_a(Array)).times(1){false}
            mock(::RVM).gemset.times(1).stub!.use.with(is_a(String)).times(1){true}
            mock(::RVM).run.with(is_a(String)).times(1){true}
            @rvmrc_processor.install_gem("ruby-1.9.2-p136",["bundler", "1.0.10"])
          end
        end
        context "when the gem is installed" do
          it "should not install given gem into all ruby+gemsets parsed from .rvmrc files beneath a root folder" do
            #mock(::RVM).use.with(is_a(String)).times(1){true}
            stub(@rvmrc_processor).gem_available?.with(is_a(Array)).times(8){true}
            mock(::RVM).gemset.times(0).stub!.use.with(is_a(String)).times(0){true}
            mock(::RVM).run.with(is_a(String)).times(0){true}
            @rvmrc_processor.install_gem("ruby-1.9.2-p136",["bundler", "1.0.10"])
          end
        end
      end

      describe "#current_ruby_info" do
        it "should return the parsed .rvmrc info for the current ruby" do
          @rvmrc_processor.current_ruby_info('ruby-1.9.2-p136').each do |hsh|
             hsh.keys.should == [:ruby_alias, :gemset_alias, :gemset_name, :gemset_path]
          end
        end
      end

      describe "#setup_rubies " do
        it "should raise an error if RVM's install root does not exist" do
          lambda{ ::Cuken::Api::Rvm::RvmrcProcessor.new('/junk') }.should raise_error(Errno::ENOENT, /No such file or directory/)
        end
        context "when RVM ruby exists " do
          it "should not install a Ruby listed in the .rvmrc files" do
            rvm_now=(`rvm current`)[/(.*)@/,1]
            mock(::RVM).list_strings.times(1).stub!.include?.with(is_a(String)).times(1){true}
            mock(::RVM).alias_create.with(/cuken_/,is_a(String)).times(1) { true }
            stub(@rvmrc_processor).install_rubie.with(is_a(String)).times(0){true}
            @rvmrc_processor.setup_rubies.should have(1).item
          end
        end
        context "when RVM ruby does not exist " do
          it "should install a Ruby listed in the .rvmrc files" do
            rvm_now=(`rvm current`)[/(.*)@/,1]
            mock(::RVM).list_strings.times(1).stub!.include?.with(is_a(String)).times(1){false}
            mock(::RVM).alias_create.with(/cuken_/,is_a(String)).times(1) { true }
            stub(@rvmrc_processor).install_rubie.with(is_a(String)).times(1){true}
            @rvmrc_processor.setup_rubies.should have(1).item
          end
        end
      end
      describe "#rvm_path" do
        it "should return a Pathname of the rvm_path environment variable" do
          ::FakeFS.deactivate!
            @rvmrc_processor.rvm_path.should be_kind_of Pathname
          ::FakeFS.activate!
        end
        it "should return the path to RVM's install root if it exists" do
          ::FakeFS.deactivate!
            @rvmrc_processor.rvm_path.directory?.should be_true
          ::FakeFS.activate!
        end
        it "should raise an error if RVM's install root does not exist" do
          FakeFS { lambda{ @rvmrc_processor.rvm_path}.should raise_error(RuntimeError, /Could not find RVM's .rvm folder/) }
        end
      end
    end
  end
end
