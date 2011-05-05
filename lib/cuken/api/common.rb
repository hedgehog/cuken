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

#
# We strip ANSI code from output strings.
#
module ::Aruba
  class Process
    def remove_ansi_codes(str)
      str.gsub(/\e\[(\d+)m/, '')
    end
    def stdout
      wait_for_io do
        @out.rewind
        remove_ansi_codes(@out.read)
      end
    end
    def stderr
      wait_for_io do
        @err.rewind
        remove_ansi_codes(@err.read)
      end
    end
  end
end
