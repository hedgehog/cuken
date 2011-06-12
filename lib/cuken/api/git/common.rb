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
      module Common

        include ::Grit
        ::Grit.debug = true
        attr_accessor :git_uri,
                      :local_git_repo,
                      :remote_git_repo


        def git
          @remote_git_repo ||= "git://github.com/cookbooks/chef-repo.git"
          @git ||= self
        end

      end
    end
  end
end
