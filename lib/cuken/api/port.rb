require 'etc'
require 'socket'
require 'timeout'

module Cuken
  module Api
    module Port
      include Etc

      MAX_PORT = 65535
      TIMEOUT_SEC = 1
      DEFAULT_HOST = 'localhost'

      def port_is_open?(port,host = DEFAULT_HOST)
        host ||= DEFAULT_HOST
        return false unless port.to_i.between?(0,MAX_PORT)
        begin
          Timeout::timeout(TIMEOUT_SEC) do
            begin
              s = TCPSocket.new(host,port)
              s.close
              return true
            rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH
              return false
            end
          end
          rescue Timeout::Error
        end
        return false
      end

      def check_port_status(ports,open,host = DEFAULT_HOST)
        host ||= DEFAULT_HOST
        ports.each do |port|
          if open
            port_is_open?(port,host).should be_true
          else
            port_is_open?(port,host).should be_false
          end
        end
      end

    end
  end
end
