require 'aruba/api' unless defined? Aruba::Api
require 'etc'

module Cuken
  module Api
    module File
      include Etc

      def check_file_content(file, partial_content, expect_match, times = 1)
        regexp = regexp(partial_content)
        seen_count = 0
        prep_for_fs_check do
          content = IO.read(file)
          while (seen_count < times.to_i || content =~ regexp)do
            if content =~ regexp
              content = content.sub(regexp,'')
              seen_count+=1
            end
          end
          if expect_match
            seen_count.should == times.to_i
          else
            seen_count.should_not == times.to_i
          end
        end
      end

      def parse_mode(mode, octal=false)
        return mode.to_s if octal
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

      def check_modes(expected_mode, filename, octal = false)
        in_current_dir do
          cstats = ::File.stat(filename)
          parse_mode(cstats.mode, octal).should match /#{expected_mode}\Z/# ].should_not be_nil
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
