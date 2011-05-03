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

Given /^Assumption: (.*)$/ do |msg|
  announce_or_puts(msg)
end

Given /^Explanation: (.*)$/ do |msg|
  announce_or_puts(msg)
end

Given /^Instruction: (.*)$/ do |msg|
  announce_or_puts(msg)
end

And /^wait "([^"]*)" seconds$/ do |delay|
    ::Kernel.sleep(delay.to_f)
end

Given /^the working directory is "([^"]*)"$/ do |path|
  @dirs = [path]
end