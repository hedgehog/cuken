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
World(::Cuken::Api::Chef::Role)

When /^I load the Cookbook Roles:$/ do |table|
  load_role_table(table)
end

And /^these Roles exist:$/ do |table|
  check_role_table_presence(table)
end

And /^these Roles do not exist:$/ do |table|
  check_role_table_presence(table, false)
end

###
# Given
###

###
# When
###
#When /^I load the Cookbook Roles:$/ do |table|
#  # table is a Cucumber::Ast::Table
#  pending # express the regexp above with the code you wish you had
#end

###
# Then
###
Then /^the Roles are:$/ do |partial_output|
  run_knife_command('role list')
  all_stdout.should include(partial_output)
end

#Then /^these Roles exist:$/ do |table|
#  run_knife_command('role list')
#  pending # express the regexp above with the code you wish you had
#end
