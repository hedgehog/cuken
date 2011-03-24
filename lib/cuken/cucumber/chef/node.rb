#
# Author:: Adam Jacob (<adam@opscode.com>)
# Copyright:: Copyright (c) 2008 Opscode, Inc.
# License:: Apache License, Version 2.0
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

###
# Given
###
Given /^a validated node$/ do
  # client should have cached ohai assigned to it
  client.register
  client.build_node
  client.node.run_list << "integration_setup"
end

###
# Then
###
Then /^the nodes are:$/ do |partial_output|
  run_knife_command('node list')
  all_stdout.should include(partial_output)
end
