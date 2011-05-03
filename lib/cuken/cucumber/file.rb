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
load 'aruba/cucumber.rb' unless defined? ::Aruba
World(::Cuken::Api::File)

#
# Refactorings, yet to be submitted to Aruba:
#
Given /^the directory "([^"]*)"$/ do |arg1|
  Then %Q{a directory named \"#{arg1}\"}
end

Given /^the file "([^"]*)" contains nothing$/ do |file_name|
  Given %Q{an empty file named "#{file_name}"}
end

Given /^the file "([^"]*)" contains:$/ do |file_name, file_content|
  Given %Q{a file named "#{file_name}" with:}, file_content
end

When /^I write to "([^"]*)":$/ do  |file_name, file_content|
  When %Q{I write to "#{file_name}" with:}, file_content
end

When /^I overwrite "([^"]*)":$/ do  |file_name, file_content|
  When %Q{I overwrite "#{file_name}" with:}, file_content
end

When /^I append to "([^"]*)":$/ do  |file_name, file_content|
  When %Q{I append to "#{file_name}" with:}, file_content
end

Then /^the file "([^"]*)" exists$/ do |arg1|
  Then %Q{a file named \"#{arg1}\" should exist}
end

Then /^the file "([^"]*)" does not exist$/ do |arg1|
  Then %Q{a file named \"#{arg1}\" should not exist}
end

Then /^the directory "([^"]*)" exists$/ do |arg1|
  Then %Q{a directory named \"#{arg1}\" should exist}
end

Then /^the directory "([^"]*)" does not exist$/ do |arg1|
  Then %Q{a directory named \"#{arg1}\" should not exist}
end

Then /^the file "([^"]*)" contains "([^"]*)"$/ do |file, content|
  Then %Q{the file "#{file}" should contain "#{content}"}
end

Then /^the file "([^"]*)" does not contain "([^"]*)"$/ do |file, content|
  Then %Q{the file "#{file}" should not contain "#{content}"}
end

Then /^the file "([^"]*)" contains \/([^\/]*)\/$/ do |file, re|
  Then %Q{the file "#{file}" should match /#{re}/}
end

Then /^the file "([^"]*)" does not contain \/([^\/]*)\/$/ do |file, re|
  Then %Q{the file "#{file}" should not match /#{re}/}
end

Then /^the file "([^"]*)" contains exactly:$/ do |file, content|
  Then %Q{the file "#{file}" should contain exactly:}, content
end

Then /^the file "([^"]*)" does not contain exactly:$/ do |file, content|
  Then %Q{the file "#{file}" should not contain exactly:}, content
end

Then /^these directories exist:$/ do |table|
  Then %Q{the following directories should exist:}, table
end

Then /^these directories do not exist:$/ do |table|
  Then %Q{the following directories should not exist:}, table
end

Then /^these files exist:$/ do |table|
  Then %Q{the following files should exist:}, table
end

Then /^these files do not exist:$/ do |table|
  Then %Q{the following files should exist:}, table
end

#
# Cuken specific
#
Given /^we record the a-mtime of "([^"]*)"$/ do |filename|
  record_amtimes(filename)
end

#
# Placing and placed files and folders refer to taking a file for Aruba's scratch folder, moving it
# outside of that ephemeral area and verifying the contents.
#
When /^I place "([^"]*)" in "([^"]*)"$/ do |src, dst|
  place_file(src, dst)
end

And /^the placed directory "([^"]*)" exists$/ do |directory|
  check_placed_directory_presence([directory], true)
end

And /^the placed directory "([^"]*)" does not exist$/ do |directory|
  check_placed_directory_presence([directory], false)
end

Then /^the directory "([^"]*)" has decimal mode "(\d+)"$/ do |dirname, expected_mode|
  check_modes(expected_mode, dirname)
end

Then /^the directory "([^"]*)" has octal mode "(\d+)"$/ do |dirname, expected_mode|
  check_modes(expected_mode, dirname, true)
end

Then /^the directory "([^"]*)" is owned by "([^"]*)"$/ do |dirname, owner|
  check_uid(dirname, owner)
end

And /^I place all in "([^"]*)" in "([^"]*)"$/ do |src_dir_name, dest_dir_name|
  place_folder_contents(dest_dir_name, src_dir_name)
end

And /^the placed file "([^"]*)" contains:$/ do |file, partial_content|
  check_placed_file_content(file, partial_content, true)
end

And /^the placed file "([^"]*)" contains "([^"]*)"$/ do |file, partial_content|
  check_placed_file_content(file, partial_content, true)
end

And /^the placed file "([^"]*)" exists$/ do |file|
  check_placed_file_presence([file], true)
end

And /^the placed file "([^"]*)" does not exist$/ do |file|
  check_placed_file_presence([file], false)
end

Then /^the file "([^"]*)" is owned by "([^"]*)"$/ do |filename, owner|
  check_uid(filename, owner)
end

Then /^the (.)time of "([^"]*)" changes$/ do |time_type, filename|
  check_amtime_change(filename, time_type)
end

Then /^the file "([^"]*)" contains "([^"]*)" exactly "(\d+)" times$/ do |file, partial_content, times|
 check_file_content(file, partial_content, true, times)
end

Then /^the file "([^"]*)" does not contain "([^"]*)" exactly "(\d+)" times$/ do |file, partial_content, times|
 check_file_content(file, partial_content, false, times)
end

Then /^the file "([^"]*)" has octal mode "(\d+)"$/ do |filename, expected_mode|
  check_modes(expected_mode, filename, true)
end

Then /^the file "([^"]*)" has decimal mode "(\d+)"$/ do |filename, expected_mode|
  check_modes(expected_mode, filename)
end
