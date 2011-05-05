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
#load 'aruba/cucumber.rb' unless defined? ::Aruba

#World(::Cuken::Api::Cmd)

#
# These ought be submitted to Aruba...
#
Then /^the output from "([^"]*)" contains exactly:$/ do |cmd, exact_output|
  output_from(unescape(cmd)).should == exact_output
end

Then /^the output from "([^"]*)" does not contain exactly:$/ do |cmd, exact_output|
  output_from(unescape(cmd)).should_not == exact_output
end

Then /^the output from "([^"]*)" contains:$/ do |cmd, partial_output|
  output_from(unescape(cmd)).should =~ regexp(partial_output)
end

Then /^the output from "([^"]*)" does not contain:$/ do |cmd, partial_output|
  output_from(unescape(cmd)).should_not =~ regexp(partial_output)
end

Then /^the output from "([^"]*)" contains "([^"]*)"$/ do |cmd, partial_output|
  output_from(cmd).should include(partial_output)
end

Then /^the output from "([^"]*)" does not contain "([^"]*)"$/ do |cmd, partial_output|
  output_from(cmd).should_not include(partial_output)
end
