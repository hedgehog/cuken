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
Before('@git_quick') do
  ::Grit::Git.git_timeout = 20
end
Before('@git_slow') do
  ::Grit::Git.git_timeout = 60
end
Before('@git_glacial') do
  ::Grit::Git.git_timeout = 600
end
Before('@git_cosmic') do
  ::Grit::Git.git_timeout = 3600
end
