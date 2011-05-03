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
      module VM
        attr_accessor :name
        attr_writer :path
        attr_reader :vm, :vagrant_vm

        def initialize(name)
          e = environment
          @vagrant_vm = ::Vagrant::VM.new(:env => e, :name => name)
          @vm = {}
          @name = name
          environment.vm = {}
          get_vm(name)
          @vagrant_vm
        end

        def vm_config
          @vm_config ||= environment.instance_variable_get(:@config).instance_variable_get(:@vm)
        end

        def vms
          @vms = environment.instance_variable_get(:@vms)
        end

#        def name
#          @name ||= 'cuken'
#        end

        def uuid
          @vm.uuid
        end

        def path
          @path ||= Pathname.pwd
        end

        def vagrantfile
          vf = path + 'Vagrantfile'
          vf.exist? ? vf : nil
        end

        def environment
            @environment = ::Vagrant::Environment.new(:cwd => path).reload_config!
        end

        def get_vm(box_name)
          unless environment.multivm?
            @vm[:primary] = environment.primary_vm
          else
            if box_name
              @vm[box_name.to_sym] = environment.vms[box_name.to_sym]
            else
              tmpvm = environment.vms.first
              @vm[tmpvm[0]] = tmpvm[1]
            end
          end
          environment.vm = @vm
        end

        def configuration
          @configuration ||= instance_variable_get :@config
        end

        def state(name)
          vm[name.to_sym].vm.state
        end

        def run_vagrant_cli(cmd, vm_name)
          ::Vagrant::CLI.start([cmd, vm_name], :env => environment)
        end

        def up(vm_name = name)
          run_vagrant_cli(__method__.to_s, vm_name)
        end

        def destroy(vm_name = name)
          run_vagrant_cli(__method__.to_s, vm_name)
        end

        def halt(vm_name = name)
          run_vagrant_cli(__method__.to_s, vm_name)
        end

        def provision(vm_name = name)
          run_vagrant_cli(__method__.to_s, vm_name)
        end

        def status(vm_name = name)
          run_vagrant_cli(__method__.to_s, vm_name)
        end

        def suspend(vm_name = name)
          run_vagrant_cli(__method__.to_s, vm_name)
        end

        def resume(vm_name = name)
          run_vagrant_cli(__method__.to_s, vm_name)
        end

        def reload(vm_name = name)
          run_vagrant_cli(__method__.to_s, vm_name)
        end

      end
    end
  end
end
