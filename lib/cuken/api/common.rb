require 'cuken/api/aruba'

module ::Cuken
  module Api
    module Common

      def with_args(*args)
        backup = ARGV.dup
        begin
          ARGV.replace(args)
          yield
        rescue Exception => e
          puts e.backtrace.join("\n") if $!.respond_to?(:status) && $!.status && $!.status > 0
        ensure
          ARGV.replace(backup)
        end
      end

    end
  end
end

