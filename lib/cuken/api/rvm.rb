require 'rvm'
require 'cuken/api/common'
require 'cuken/api/rvm/common'
require 'cuken/api/rvm/gemsets'
require 'cuken/api/rvm/rubies'

module ::Cuken
  module Api
    module Rvm

      extend ::RVM
      include ::Cuken::Api::Rvm::Common
      include ::Cuken::Api::Aruba::Api

      class RvmHelper

        attr_reader :environment

        def init
          RVM::Environment
        end

        def current
          @current = RVM.current
        end

        def environment_name
          current.environment_name
        end

        def gemset
          current.gemset
        end

        def environment(gemset, options={})
          @environment = self.new(gemset, options)
          yield @environment if block_given?
          @environment
        end
      end

      def rvm
        @rvm ||= RvmHelper.new
      end
    end
  end
end

