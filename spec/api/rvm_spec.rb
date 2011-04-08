require Pathname(__FILE__).ascend { |d| h=d+'spec_helper.rb'; break h if h.file? }

#Reference:
# http://www.metaskills.net/2010/07/30/the-rvm-ruby-api/

module ::Cuken::Api
  describe Rvm do
    before(:all) do
      include ::Cuken::Api::Rvm
#      ::FakeFS.activate!
#      ::FakeFS::FileSystem.clear
      @rvmrc_root = setup_rvmrc_gems_files(1)
      @rvmrc_file = Dir.glob(@rvmrc_root + '/**' + '/.rvmrc')[-1]
    end
    before(:each) do
      puts self.class
      @rvmrc_processor= ::Cuken::Api::Rvm::RvmrcProcessor.new(@rvmrc_file)
    end
    after(:all) do
#      ::FakeFS.deactivate!
    end
#    context ".b3_setup" do
#      it "should set the path to BigBlueButton's sources root" do
#         ::Cuken::Api::Rvm.rvm_setup.directory?.should be_true
#      end
#      it "should raise an error if the path to BigBlueButton's sources root does not exist" do
#        FakeFS { lambda{ ::B3::Bdd::Helpers.b3_setup}.should raise_error(RuntimeError, /Could not find BigBlueButton's sources root./) }
#      end
#    end

    describe ".rvm_current_name" do
      it "should return the full rubie and gemset name" do
        ::Cuken::Api::Rvm.rvm_current_name.should =~ /ruby(.*)@(.*)/
      end
    end

    describe ".rvm_path" do
      it "should return a Pathname of the rvm_path environment variable" do
        ::Cuken::Api::Rvm.rvm_path.should be_kind_of Pathname
      end
      it "should return the path to RVM's install root if it exists" do
         ::Cuken::Api::Rvm.rvm_path.directory?.should be_true
      end
      it "should raise an error if RVM's install root does not exist" do
        FakeFS { lambda{ ::Cuken::Api::Rvm.rvm_path}.should raise_error(RuntimeError, /Could not find RVM's .rvm folder/) }
      end
    end
    describe ".rvm_local_install?" do
      it "should indicate RVM is installed locally" do
        ::Cuken::Api::Rvm.rvm_local_install?.should be_true
      end
    end

    context ".rvm_loaded? with RVM" do
      it "should return true when RVM is installed locally" do
        ::Cuken::Api::Rvm.rvm_loaded?.should be_true
      end
    end

    context ".rvm_loaded? without RVM" do
      it "should return false when RVM is not installed locally" do
        FakeFS do
          ::Cuken::Api::Rvm.rvm_loaded?.should be_false
        end
      end
    end

    context ".rvm_gemset_paths with root path argument" do
      it "should return default paths requiring RVM gemsets be loaded" do
        FakeFS do
          root_path = setup_rvmrc_gems_files(8)
          ::Cuken::Api::Rvm.rvm_gemset_paths(root_path).should have(9).items
        end
      end
    end

    context ".rvmrc_rubies_gemsets without root path argument" do
      it "should return a hash whose keys are rubies (in the .rvmrc files)" do
        FakeFS do
          root_path = setup_rvmrc_gems_files(1)
          ::Cuken::Api::Rvm.rvmrc_rubies_gemsets(root_path).should be_kind_of(Hash)
          ::Cuken::Api::Rvm.rvmrc_rubies_gemsets(root_path).keys.each {|k| k.should match /ruby/ }
        end
      end
      it "should return a hash whose values are array of gemsets (in the .rvmrc files)" do
        ::Cuken::Api::Rvm.rvmrc_rubies_gemsets.each do |k, v|
          k.should match /ruby/
          v.should be_kind_of(Array)
          v.each{|elem| elem.should be_kind_of(Hash) }
        end
      end
      it "should return RVM gemsets names that exist in the .rvmrc files" do
        FakeFS do
          root_path = setup_rvmrc_gems_files(8)
          res = ::Cuken::Api::Rvm.rvmrc_rubies_gemsets(root_path)
          res.should have(1).item
          res.first.last.should have(9).items
        end
      end
    end

    context ".rvmrc_rubies without root path argument" do
      it "should return RVM Ruby names that exist in the .rvmrc files" do
          ::Cuken::Api::Rvm.rvm_install_rubies = {'ruby-1.9.2-p136'   => {:alias => 'cuken192'}}
          res = ::Cuken::Api::Rvm.rvmrc_rubies
          res.should have(1).item
          res.first.should have(2).items
      end
      it "should contain an alias with prefix cuken-" do
        ::Cuken::Api::Rvm.rvmrc_rubies.each do |k, v|
          v[:alias].should match /\Acuken-/
        end
      end
    end

    context ".rvm_rubies_setup without root path argument" do
      it "should raise an error if RVM's install root does not exist" do
        FakeFS { lambda{ ::Cuken::Api::Rvm.rvm_rubies_setup}.should raise_error(RuntimeError, /RVM library not loaded./) }
      end
      it "should not install existing RVM rubies that exists in the .rvmrc files" do
        rvm_now=(`rvm current`)[/(.*)@/,1]
        mock(::RVM).install(rvm_now,{}).times(0){true}
        mock(::RVM).alias_create.with(is_a(String),/@vagrant/).times(1) { true }
        ::Cuken::Api::Rvm.rvm_rubies_setup.should have(1).item
      end
    end

    describe ".rvm_install_gemspecs" do
      it "should return an array of 2-element arrays with gem name and version" do
        ::Cuken::Api::Rvm.rvm_install_gemspecs << ['gem_a', '1.0.0']
        ::Cuken::Api::Rvm.rvm_install_gemspecs << ['gem_b', '2.0.0']
        ::Cuken::Api::Rvm.rvm_install_gemspecs.should == [["bundler", "1.0.10"], ["gem_a", "1.0.0"], ["gem_b", "2.0.0"]]
      end
    end

    describe ".rvm_create_gemsets" do
      it "should return an array of gemsets names" do
        ::Cuken::Api::Rvm.rvm_create_gemsets << 'gemset_a'
        ::Cuken::Api::Rvm.rvm_create_gemsets << 'gemset_b'
        ::Cuken::Api::Rvm.rvm_create_gemsets.should == ["gemset_a", "gemset_b"]
      end
    end

    context ".rvmrc_gems_install" do
      it "should require a directory path argument" do
        lambda{::Cuken::Api::Rvm.rvmrc_gems_install}.should  raise_error(ArgumentError, /wrong number of arguments \(0 for 1\)/)
      end
    end

    context ".rvmrc_gems_install when gem is not installed" do
      it "should install gems added to rvm_install_gemspecs" do
        FakeFS do
          root_path = setup_rvmrc_gems_files(8)
          ::Cuken::Api::Rvm.rvm_install_gemspecs << ['gem_a', '1.0.0']
          ::Cuken::Api::Rvm.rvm_install_gemspecs << ['gem_b', '2.0.0']
          mock(::RVM).use.with("ruby-1.9.2-p136").times(2){true}
          #mock(::RVM).gemset.stub!.create.with(is_a(String)).times(9){true}
          mock(::RVM).gemset.times(27).stub!.use!.with(is_a(String)).times(27){true}
          # mock(::RVM).gemset_import.with(is_a(String)).times(8) { true }
          #mock(::RVM).perform_set_operation.with(is_a(Symbol),is_a(String),is_a(String),is_a(String),is_a(String)).times(4){ stub!.stdout{ "some progress messages" } }
          #mock(::RVM).perform_set_operation.with(is_a(Symbol),is_a(String),is_a(String),is_a(String),is_a(String)).times(4){ stub!.stdout{ "some progress messages" } }
          mock(::RVM).ruby_eval.with(is_a(String)).times(27){ stub!.stdout{'false'}}
          mock(::RVM).run.with(is_a(String)).times(27){ stub!.stdout{'false'}}
          ::Cuken::Api::Rvm.rvmrc_gems_install(root_path).should be_true
        end
      end
    end

    context ".rvmrc_gems_install when gem is installed" do
      it "should not install gems added to rvm_install_gemspecs" do
        FakeFS do
          root_path = setup_rvmrc_gems_files(8)
          ::Cuken::Api::Rvm.rvm_install_gemspecs << ['gem_a', '1.0.0']
          ::Cuken::Api::Rvm.rvm_install_gemspecs << ['gem_b', '2.0.0']
          stub(::RVM).use.verbose.with(is_a(String))
          #stub(::RVM).gemset.times(27).stub!.create.verbose.with(is_a(Array)).times(27){true}
          stub(::RVM).gemset.times(27).stub!.use.verbose.with(is_a(String)).times(27){true}
          # mock(::RVM).use.with(is_a(String)).times(1){true}
          # mock(::RVM).gemset_import.with(is_a(String)).times(8) { true }
          mock(::RVM).perform_set_operation.with(is_a(Symbol),is_a(String),is_a(String),is_a(String),is_a(String)).times(0){ stub!.stdout{ "some progress messages" } }
          mock(::RVM).ruby_eval.with(is_a(String)).times(27){ stub!.stdout{'true'}}
          ::Cuken::Api::Rvm.rvmrc_gems_install(root_path).should be_true
        end
      end
    end

#    context ".rvmrc_gemsets_install when gemset is not installed" do
#      it "should install gemsets found in .rvmrc files" do
#        FakeFS do
#          root_path = setup_rvmrc_gems_files(8)
#          mock(::RVM).use.with(is_a(String)).times(1){true}
#          mock(::RVM).gemset_import.with(is_a(String)).times(8) { true }
#          #mock(::RVM).perform_set_operation.with(is_a(Symbol),is_a(String),is_a(String),is_a(String),is_a(String)).times(3){ stub!.stdout{ "some progress messages" } }
#          #mock(::RVM).ruby_eval.with(is_a(String)).times(3){ stub!.stdout{'false'}}
#          ::Cuken::Api::Rvm.rvmrc_gems_install(root_path).should be_true
#        end
#      end
#    end
#
#    context ".rvmrc_gemsets_install" do
#      it "should require a directory path argument" do
#        lambda{::Cuken::Api::Rvm.rvmrc_gemsets_install}.should  raise_error(ArgumentError, /wrong number of arguments \(0 for 1\)/)
#      end
#    end

    describe ".rvm_steup" do
      it "should require RVM and the libraries this API requires"
    end

    describe "_rvm_current_rubie_name" do
      it "should return the rubie name without any gemset"
    end
    describe "#rvm_gem_available?(spec)" do
      it "should expect gem name and version as an array"
      it "should return true if the gem can be required"
    end
  end
end

#module B3
#  module Bdd
#    module Helpers
#
#    end
#  end
#end
#describe ::B3::Bdd::Helpers do
#  context ".b3_setup" do
#    it "should set the path to BigBlueButton's sources root" do
#       ::B3::Bdd::Helpers.b3_setup.directory?.should be_true
#    end
#    it "should raise an error if the path to BigBlueButton's sources root does not exist" do
#      FakeFS { lambda{ ::B3::Bdd::Helpers.b3_setup}.should raise_error(RuntimeError, /Could not find BigBlueButton's sources root./) }
#    end
#  end
#
#  context ".b3_bdd_feature_sets(hsh)" do
#    it "should return the subset of hash having feature sets" do
#      hsh = ::B3::Bdd::Helpers.b3_bdd_feature_sets
#      hsh.first.last.should have(3).items
#      hsh.should be_kind_of(Hash)
#      hsh.each do |k, v|
#              k.should match /ruby/
#              v.each{|elem| elem.key? :feature_set_name }
#      end
#    end
#  end
#
#  context ".b3_bdd_features_parser" do
#    it "should accept an empty hash and return default set_profile" do
#      hsh = ::B3::Bdd::Helpers.b3_bdd_features_parser
#      hsh.keys.should == [:set_profile]
#      hsh[:set_profile].keys.should == ["bbb_bdd_app", "bbb_bdd_sys_os", "bbb_bdd_meta_bdd"]
#      hsh.each do |k, v|
#              k.should match /ruby/
#              v.each do |elem|
#                elem.key?(:feature_set_name).should be_true
#                elem.key?(:profiles).should be_true
#                elem.value(:profiles).should == ["default"]
#              end
#      end
#    end
#  end
#
#  context ".b3_bdd_run :feature" do
#    it "should run all feature sets with default Cucumber profile" do
#      mock(::RVM).use.with(is_a(String)).times(8){true}
#      mock(::RVM).use_from_path!.with(is_a(String)).times(3){true}
#      mock(::Open4).popen4.with(is_a(String)).times(3) { true }
#      ::B3::Bdd::Helpers.b3_bdd_run(:feature,{}).should be_true
#    end
#  end
#
#end
