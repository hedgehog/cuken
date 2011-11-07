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
World(::Cuken::Api::Rvm::Rubies)

Given /^the Rubie "([^"]*)" is active$/ do |rubie|
  check_rubie_activation(rubie, true)
end

Given /^the Rubie "([^"]*)" is used$/ do |rubie|
  rubie_use(rubie)
end

Given /^the Rubie "([^"]*)" is not active$/ do |rubie|
  check_rubie_activation(rubie, true)
end

Given /^the Rubie "([^"]*)" exists$/ do |rubie|
  check_rubie_presence([rubie], true)
end

Given /^the Rubie "([^"]*)" does not exist$/ do |rubie|
  check_rubie_presence([rubie], true)
end

