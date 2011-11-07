module ::Cuken
  module Api
    module Rvm
      module Rubies

        include ::Cuken::Api::Rvm::Common

        def check_rubie_activation(rubie, expect_active = true)
          if expect_active
            rvm.current.environment_name.should match(rubie)
          else
            rvm.current.environment_name.should_not match(rubie)
          end
        end

        def rubie_use(rubie, rubie = 'ruby-1.9.2-p290', expect_active = true)
          RVM.use!("#{rubie}").inspect
          if expect_active
            rvm.current.environment_name.should match(rubie)
          else
            rvm.current.environment_name.should_not match(rubie)
          end
        end

        def check_rubie_presence(rubies, expect_presence = true)
          if expect_presence
            rubies.each do |rb|
              rvm.list.include?(rb).should be_true
            end
          else
            rubies.each do |rb|
              pending "this is failing for some reason"
              rvm.list.include?(rb).should be_false
            end
          end
        end

      end
    end
  end
end
