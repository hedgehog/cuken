#
# Author:: Hedgehog (<hedgehogshiatus@gmail.com>)
# Copyright:: Copyright (c) 2011 Hedgehog.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
module ::Cuken
  module Api
    module Vagrant
      module Common

        def establish_vm_interactive_ssh(boxname)
          cmd = vagrant.vm[boxname.to_sym].ssh.ssh_connect_command
          run_interactive(unescape(cmd))
        end

        def load_vagrant_file(path, expect_presence = true)
          vagrant.path = Pathname(path).expand_path.realdirpath
          if expect_presence
            vagrant.path.exist?.should be_true
          else
            vagrant.path.exist?.should be_false
          end
        end

        def check_vagrant_file_presence(path, expect_presence = true)
          if Pathname(chef.root_dir).exist?
            in_chef_root do
              if expect_presence
                load_vagrant_file(path)
              end
            end
          else
            in_dir do
              if expect_presence
                load_vagrant_file(path)
              end
            end
          end
        end

        def check_vm_active(name, expect_active = true )
          in_chef_root do
            if expect_active
              if vagrant.environment.local_data[:active][name].nil?
                vagrant.up(name)
              end
              vagrant.environment.local_data[:active][name].should_not be_nil
            else
              if vagrant.environment.local_data[:active][name]
                vagrant.halt(name)
              end
              vagrant.environment.local_data[:active][name].should be_nil
            end
          end
        end

        def check_vm_state(name, state, expect_state = true )
          in_chef_root do
            if expect_state
              vagrant.vm[name.to_sym].vm.state.should == state
            else
              vagrant.vm[name.to_sym].vm.state.should_not == state
            end
          end
        end

        def run_vm_manager_command(cmd, vm_name, vm_manager = :vagrant)
          method(vm_manager).call.send(cmd, vm_name)
        end
      end
    end
  end
end

