require Pathname(__FILE__).ascend { |d| h=d+'spec_helper.rb'; break h if h.file? }
#Reference:
# http://www.metaskills.net/2010/07/30/the-rvm-ruby-api/
@announce = true
module ::Cuken::Api::Rvm

  describe Gemsets do

    before(:each) do
    end

    after(:all) do
    end

    context "#check_gemset_activation([gemset], true)" do
      before(:all) do
        current=`rvm current`
        @rvm_rubie_now=current[/(.*)@/,1]
        @rvm_gemset_now=current[/@(.*)/,1]
      end

      it "should confirm a given rubie and gemset is active" do
        check_gemset_activation("#{@rvm_rubie_now}@#{@rvm_gemset_now}").should be_true
      end

      it "should confirm a given rubie and gemset is not active" do
        check_gemset_activation("rvm_rubie@rvm_gemset", false).should be_false
      end

      it "should confirm a given rubie and gemset is present" do
        check_gemset_presence(["=> #{@rvm_gemset_now}"]).should be_true
      end

      it "should confirm a given rubie and gemset is not present" do
        check_gemset_presence(["rvm_gemset"], false).should be_false
      end

    end

  end
end