module ::Cuken
  module Api

    describe Rvm do

      before(:all) do
        include ::Cuken::Api::Rvm
      end

      describe ".current_name" do
        it "should return the full rubie and gemset name" do
          ::Cuken::Api::Rvm.current.expanded_name.should =~ /(.*)@(.*)/
        end

      end
    end
  end

end
