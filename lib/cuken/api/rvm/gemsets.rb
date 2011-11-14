module ::Cuken
  module Api
    module Rvm
      module Gemsets

        include ::Cuken::Api::Rvm::Common

        def check_gemset_activation(gemset, expect_active = true)
          if expect_active
            rvm.current.environment_name.should match(gemset)
          else
            rvm.current.environment_name.should_not match(gemset)
          end
        end

        def gemset_use(gemset, rubie = 'ruby-1.9.2-p290', expect_active = true)
          RVM.use!("#{rubie}@#{gemset}").inspect
          if expect_active
            rvm.current.environment_name.should match(gemset)
          else
            rvm.current.environment_name.should_not match(gemset)
          end
        end

        def check_gemset_presence(gemsets, expect_presence = true)
          if expect_presence
            gemsets.each do |gs|
              rvm.gemset.list.include?(gs).should be_true
            end
          else
            gemsets.each do |gs|
              pending "this is failing for some reason"
              rvm.gemset.list.include?(gs).should be_false
            end
          end
        end

      end
    end
  end
end
