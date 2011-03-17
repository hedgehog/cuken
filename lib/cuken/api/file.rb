require 'aruba/api' unless defined? Aruba::Api
require 'etc'

module Cuken
  module Api
    module File
      include Etc

      def parse_mode(mode)
        if mode.respond_to?(:oct)
          mode.oct.to_s(8)
        else
          '%o' % mode
        end
      end

      def record_amtimes(filename)
        in_current_dir do
          @recorded_mtime = ::File.mtime(filename)
          @recorded_atime = ::File.atime(filename)
        end
      end

      def check_octalmodes(expected_mode, filename)
        in_current_dir do
          cstats = ::File.stat(filename)
          parse_mode(cstats.mode)[/#{parse_mode(expected_mode)}\Z/].should_not be_nil
        end
      end

      def check_uid(dirname, owner)
        in_current_dir do
          uid = ::Etc.getpwnam(owner).uid
          cstats = ::File.stat(dirname)
          cstats.uid.should == uid
        end
      end

      def check_amtime_change(filename, time_type)
        in_current_dir do
          case time_type
          when "m"
            current_mtime = ::File.mtime(filename)
            current_mtime.should_not == @recorded_mtime
          when "a"
            current_atime = ::File.atime(filename)
            current_atime.should_not == @recorded_atime
          end
        end
      end

    end
  end
end
