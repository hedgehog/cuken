#
# Author:: Hedgehog (<hedgehogshiatus@gmail.com>)
# Copyright:: Copyright (c) 2011 Hedgehog.
#
# Portions of this work are derived from the Chef project
# The original license header follows:
#
# Copyright:: Copyright (c) 2011 Opscode, Inc.
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
World(::Cuken::Api::Chef::DataBag)

###
# Given
###

###
# When
###

###
# Then
###

Given /^I create the Data Bag "([^"]*)"$/ do |data_bag_name|
  data_bag_create(data_bag_name)
end

When /^I add these Cookbook Data Bag items:$/ do |table|
  load_data_bag_item_table(table)
end

Then /^these Data Bags exist:$/ do |table|
  check_data_bag_table_presence(table)
end

Then /^these Data Bags do not exist:$/ do |table|
  check_data_bag_table_presence(table, false)
end

Then /^these Data Bags contain:$/ do |table|
  check_data_bag_content_table(table)
end

Then /^these Data Bags do not contain:$/ do |table|
  check_data_bag_content_table(table, false)
end
