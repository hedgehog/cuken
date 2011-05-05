#
# Author:: Hedgehog (<hedgehogshiatus@gmail.com>)
# Copyright:: Copyright (c) 2011 Hedgehog.
# Portions of this work are derived from the Chef project
# The original license header follows:
#
# Copyright:: Copyright (c) 2008, 2010 Opscode, Inc.
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
World(::Cuken::Api::Chef::Knife)

Given /^the Knife file "([^"]*)"$/ do |path|
  in_dir do
    chef.knife_config_file = Pathname(path).expand_path.realdirpath
  end
end

When /^I successfully run Knife's "([^"]*)"$/ do |cmd|
  run_knife_command(cmd, false)
end

When /^I interactively run Knife's "([^"]*)"$/ do |cmd|
  run_knife_command(cmd, true)
end
