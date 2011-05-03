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

World(::Cuken::Api::Ssh)

Before do
  @aruba_timeout_seconds.nil? || @aruba_timeout_seconds < 5 ? @aruba_timeout_seconds = 5 : @aruba_timeout_seconds
end

Given /^a SSH client user "([^\"]*)"$/ do |name|
  ssh_client_hostname name
end

Given /^a SSH client user$/ do
  ssh_client_hostname
end

Given /^a SSH client hostname "([^\"]*)"$/ do |name|
  ssh_client_hostname name
end

Given /^a SSH client hostname$/ do
  ssh_client_hostname
end

Given /^default ssh-forever options$/ do
  ssh_forever_options(:default)
end

Given /^the ssh-forever options:$/ do |table|
  ssh_forever_options(table)
end

When /^I initialize password-less SSH access for:$/ do |table|
  ssh_init_password_less_batch(table)
end

Given /^I initialize password-less SSH access$/ do
  ssh_init_password_less
end


