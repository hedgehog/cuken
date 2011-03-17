require 'aruba/api' unless defined? Aruba::Api

module ::Cuken
  module Api
    module Common

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
