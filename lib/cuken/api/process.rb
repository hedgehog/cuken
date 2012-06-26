require 'etc'

module Cuken
  module Api
    module Process
      include Etc

      PATH_SEPARATOR = '/'

      #ensure that we're using the right column indices for ps
      #token attempt at cross-platform compatibility
      column_list = `ps aux`.split("\n")[0].split
      USER_INDEX = column_list.index("USER")
      PID_INDEX = column_list.index("PID")
      NAME_INDEX = column_list.index("COMMAND")

      #Returns the final path component of a path.
      #For a normal path, this would be the filename.
      #For a command, the flags are stripped off, leaving only
      #the name of the executable.
      def final_path_component(path)
        path.split(PATH_SEPARATOR)[-1].split[0]
      end

      #Returns a list of hashes containing information
      #about all running processes that could match proc_name.
      #The hash contains 3 keys - owner, pid, and command.
      def get_procs_by_name(proc_name)
        proc_strings = `ps aux |grep #{proc_name[0...-1]}[#{proc_name[-1]}]`.split("\n")
        procs = []
        proc_strings.each do |proc_string|
          proc_columns = proc_string.split
          proc_hash = {}
          proc_hash[:owner] = proc_columns[USER_INDEX]
          proc_hash[:pid] = proc_columns[PID_INDEX]
          proc_hash[:name] = final_path_component(proc_columns[NAME_INDEX])
          next unless proc_hash[:name] == proc_name
          procs << proc_hash
        end
        return procs
      end

      #Checks that a process with the supplied
      #attributes is running
      def check_process(name, owner=nil, pid=nil)
        procs = get_procs_by_name(name)
        procs.should_not be_empty
        return unless owner or pid
        found_good_proc = false
        procs.each do |process|
          proc_ok = true
          proc_ok &&= (process[:owner] == owner) unless not owner
          proc_ok &&= (process[:pid] == pid) unless not pid
          found_good_proc ||= proc_ok
        end
        found_good_proc.should be_true
      end

      #Checks that a process by the supplied name
      #is NOT running
      def check_process_not_running(name)
        procs = get_procs_by_name(name)
        procs.should be_empty
      end

    end
  end
end
