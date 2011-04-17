require Pathname(__FILE__).ascend { |d| h=d+'spec_helper.rb'; break h if h.file? }

module ::Cuken::Api::Chef

  describe Knife do
    before :all do
      ::Chef::Config[:node_name]  = "webmonkey.example.com"
      @knife = ::Chef::Knife::ClientCreate.new
    @knife.config = {
      :file => nil
    }
      @client = ::Chef::ApiClient.new
    end
    describe "#create_client(data)" do
      it "should create a new named admin Client" do
        data = {:name => 'Im_new_here',
                :config_file => '/some/knife.rb',
                :admin => true,
                :file => '/some/sekret.pem',
                :no_editor => true}
         any_instance_of(::Chef::ApiClient) do |u|
           stub(u).name.with(data[:name]).times(1)
           stub(u).name.with("").times(1) # some json creation routine
           stub(u).admin.with(data[:admin]).times(1)
           stub(u).admin.with(false).times(1) # some json creation routine
           stub(u).save{ { 'private_key' => 'sekret' } }
         end
         stub(Chef::Config).from_file.with(is_a(String))
        FakeFS do
          chef.knife.create_client(data)
          File.read(data[:file]).should == 'sekret'
        end
      end
      it "should create a new named non-admin Client" do
        data = {:name => 'Im_new_here',
                :config_file => '/some/knife.rb',
                :admin => false,
                :file => '/some/sekret2.pem',
                :no_editor => true}
         any_instance_of(::Chef::ApiClient) do |u|
           stub(u).name.with(data[:name]).times(1)
           stub(u).name.with("").times(1) # some json creation routine
           stub(u).admin.with(nil).times(1)
           stub(u).admin.with(false).times(1) # some json creation routine
           stub(u).save{ { 'private_key' => 'sekret2' } }
         end
        stub(Chef::Config).from_file.with(is_a(String))
        FakeFS do
          chef.knife.create_client(data)
          File.read(data[:file]).should == 'sekret2'
        end
      end
    end
    describe "#show_client(data)" do
      it "should show a named Client" do
        data = {:name => 'Im_new_here',
                :config_file => '/some/knife.rb',
                :file => '/some/sekret.pem',
                :no_editor => true}
        stub(Chef::Config).from_file.with(is_a(String))
        stub(Chef::ApiClient).load.with(data[:name]){['somthing: displayed']}
        FakeFS do
          chef.knife.show_client(data).should be_nil

        end
      end
    end
#    describe "#check_client(data)" do
#      it "should check a named Client" do
#        data = {:name => 'Im_new_here',
#                :file => '/some/sekret.pem',
#                :no_editor => true}
#        stub(Chef::Config).from_file.with(is_a(String))
#        stub(Chef::ApiClient).load.with(data[:name]){['somthing: displayed']}
#        FakeFS do
#          chef.knife.check_client(data).should match /somthing: displayed/
#         end
#      end
#    end
    describe "#delete_client(data)" do
      it "should delete a named Client" do
        data = {:name => 'Im_new_here',
                :config_file => '/some/knife.rb',
                :file => '/some/sekret.pem',
                :no_editor => true}
        stub(Chef::Config).from_file.with(is_a(String))
        stub(Chef::ApiClient).load.with(data[:name]){stub!.destroy{true}}
        FakeFS do
          chef.knife.delete_client(data).should be_nil
        end
      end
    end
  end
end
