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

      def place_file(src, dst)
        dest = Pathname(dst).expand_path.realdirpath
        FileUtils.mkdir_p((dest+src).dirname.to_s)
        in_current_dir do
          opts = {:verbose => true, :preserve => true, :remove_destination => true}
          FileUtils.cp_r(src, (dest+src).to_s, opts).should be_nil
          FileUtils.compare_file(src, (dest+src).to_s).should be_true
        end
      end

      def place_folder_contents(dest_dir_name, src_dir_name)
        dest = Pathname(dest_dir_name).expand_path.realdirpath
        dest_parent = dest.dirname.to_s
        FileUtils.mkdir_p((dest+src_dir_name).to_s)
        in_current_dir do
          opts = {:verbose => true, :preserve => true, :remove_destination => true}
          FileUtils.cp_r(src_dir_name+'/.', dest.to_s, opts).should be_nil
        end
        Dir.glob("#{src_dir_name}/**/*").each do |fn|
          if File.file?(fn)
            fn2 = File.join(dest_parent, fn)
            FileUtils.compare_file(fn, fn2).should be_true
          end
        end
      end

      def check_placed_file_content(file, partial_content, expect_match)
        prep_for_placed_fs_check do
          content = IO.read(file)
          if expect_match
            content.should include partial_content
          else
            content.should_not include partial_content
          end
        end
      end

      def prep_for_placed_fs_check(&block)
        stop_processes!
        block.call
      end

      def check_placed_file_presence(paths, expect_presence)
        prep_for_placed_fs_check do
          paths.each do |path|
            if expect_presence
              ::File.should be_file(path)
            else
              ::File.should_not be_file(path)
            end
          end
        end
      end

      def check_placed_directory_presence(paths, expect_presence)
        prep_for_placed_fs_check do
          paths.each do |path|
            if expect_presence
              dest = Pathname(path).expand_path.realdirpath
              Pathname(dest).mkpath
              Pathname(path).should be_directory
            else
              Pathname(path).should_not be_directory
            end
          end
        end
      end

    end
  end
end
