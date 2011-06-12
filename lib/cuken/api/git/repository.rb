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
    module Git
      module Repository

        def parse_to_repository_path(hsh)
          case
            when not(hsh['repo'].nil? || hsh['repo'].empty?)
              ckbk = hsh['repo']
              ckbk_src = "#{ckbk}"
            when not(hsh['repository'].nil? || hsh['repository'].empty?)
              ckbk = hsh['repository']
              ckbk_src = "#{ckbk}"
            else
              src =""
          end
          return ckbk, ckbk_src
        end

        def check_repository_table_presence(table, expect_presence = true, curr_dir = current_dir)
          table.hashes.each do |hsh|
            ckbk, ckbk_src = parse_to_repository_path(hsh)
            full_repo_src = ckbk
            announce_or_puts(%{Looking for repository: #{full_repo_src}}) if @announce_env
            check_repository_presence(full_repo_src, expect_presence, curr_dir)
          end
        end

        def check_repository_presence(repo, expect_presence = true, curr_dir = current_dir)
          in_dir(curr_dir) do |pn|
            curr_path = Pathname(pn).basename.to_s
            condition = Pathname(pn).exist?
            given_repo = Pathname(repo).basename.to_s if repo
            result = given_repo == curr_path
            if condition && result
              given_repo.should == curr_path
              announce_or_puts(%{Found cookbook: #{pn}}) if @announce_env
            end
          end
        end

      end
    end
  end
end

