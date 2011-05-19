require Pathname(__FILE__).ascend { |d| h=d+'spec_helper.rb'; break h if h.file? }
@announce = true
module ::Cuken::Api::Vagrant

  describe VM do

    before(:each) do
    end

    after(:all) do
    end

    context "#state(name)" do
      before(:all) do
        in_dir do
          puts Dir.getwd
          File.open("Vagrantfile", "w") { |f| f << test_vagrantfile(['web','db']) }
          @vagrant_vm = ::VagrantVMExampleHelpers.create_vm_instance('web')
        end

      end
      after(:all) do
        in_dir do
          FileUtils.rm('Vagrantfile')
        end
      end

      it "should confirm a non-existent VM is not running" do
        in_dir do
          @vagrant_vm.state(:web).should be_nil
        end
      end

    end

  end
end