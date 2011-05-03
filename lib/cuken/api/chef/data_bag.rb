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
      module DataBag

        include ::Cuken::Api::Common

        def load_data_bag_item_table(table)
          table.hashes.each do |hsh|
            data_bag_load(hsh)
          end
        end

        def check_data_bag_table_presence(table, expect_presence = true)
          bags = data_bag_list
          table.hashes.each do |hsh|
            if expect_presence
              bags.should include(hsh['data_bag'])
            else
              bags.should include(hsh['data_bag'])
            end
          end
        end

        def check_data_bag_content_table(table, expect_match = true)
          table.hashes.each do |hsh|
            items = data_bag_show(hsh['data_bag'])
            if expect_match
              items.should include(hsh['item'])
            else
              items.should_not include(hsh['item'])
            end
          end
        end

        def data_bag_create(data_bag_name)

          knife_config_file_error_handling()

          argv = ['data', 'bag', 'create', data_bag_name]
          run_knife(argv)
        end

        def data_bag_load(hsh)

          knife_config_file_error_handling()

          ckbk, ckbk_src = parse_to_cookbooks_path(hsh)
          full_data_bag_src = find_path_in_cookbook_folders(ckbk, ckbk_src, ckbk, "data_bags/#{hsh['item']}")
          argv = ['data', 'bag', 'from', 'file', hsh[:data_bag], full_data_bag_src]
          run_knife(argv)
        end

        def data_bag_list

          knife_config_file_error_handling()

          argv = ['data', 'bag', 'list']
          run_knife(argv)
        end

        def data_bag_show(data_bag)

          knife_config_file_error_handling()

          argv = ['data', 'bag', 'show', data_bag]
          run_knife(argv)
        end

      end
    end
  end
end
