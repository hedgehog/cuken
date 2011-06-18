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
    module Chef
      module Role

        include ::Cuken::Api::Common

        def load_role_table(table)
          in_chef_root do
            table.hashes.each do |hsh|
              case
                when !(hsh['cookbook'].nil? || hsh['cookbook'].empty?)
                  src = "cookbooks/#{hsh['cookbook']}/roles/#{hsh['role']}"
                when !(hsh['site-cookbook'].nil? || hsh['site-cookbook'].empty?)
                  src = "site-cookbooks/#{hsh['site-cookbook']}/roles/#{hsh['role']}"
                else
                  src =""
              end
              role_load(::File.expand_path(src))
            end
          end
        end

        def role_load(src)

          knife_config_file_error_handling()

          argv = ['role', 'from', 'file', src]
          run_knife(argv)
        end

        def role_list

          knife_config_file_error_handling()

          argv = ['role', 'list']
          run_knife(argv)
        end

        def check_role_table_presence(table, expect_presence = true)
          roles = role_list
          table.hashes.each do |hsh|
            if expect_presence
              roles.should include(hsh['role'])
            else
              roles.should_not include(hsh['role'])
            end
          end
        end

      end
    end
  end
end

