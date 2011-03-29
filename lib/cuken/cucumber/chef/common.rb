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
World(::Cuken::Api::Chef)

Before do
  @aruba_timeout_seconds.nil? || @aruba_timeout_seconds < 3 ? @aruba_timeout_seconds = 3 : @aruba_timeout_seconds
end

Given /^the Chef server URI "([^"]*)"$/ do |uri|
  chef.uri = uri
end

Given /^the Chef client "([^"]*)"$/ do |name|
  chef.client_name =  name
end

Given /^the Chef admin client "([^"]*)"$/ do |name|
  chef.admin_client_name =  name
end

Given /^the Chef client private key path "([^"]*)"$/ do |path|
  in_current_dir do
    chef.client_private_key_path = Pathname(path)
  end
end

Given /^the remote Chef repository "([^"]*)"$/ do |chf_pth|
  in_current_dir do
    if Pathname(chf_pth).exist?
      chef.remote_chef_repo = Pathname(chf_pth).expand_path.realdirpath
    else
      chef.remote_chef_repo = chf_pth
    end
  end
end

Given /^the local Chef repository "([^"]*)"$/ do |chf_pth|
  in_current_dir do
    chef.local_chef_repo = Pathname(chf_pth).expand_path.realdirpath
  end
end

Then /^the local Chef repository exists$/ do
  chef.local_chef_repo.exist?.should be_true
  #TODO: check_file_presence([file], true), etc.
end

Given /^I clone the remote Chef repository branch "([^"]*)" to "([^"]*)"$/ do |brnch, path|
  chef.local_chef_repo = chef_clone_repo(path, false, chef.remote_chef_repo, brnch)
  chef.local_chef_repo.exist?.should be_true
end

Given /^a default base Chef repository in "([^"]*)"$/ do |path|
  chef.local_chef_repo = chef_clone_repo(path)
  chef.local_chef_repo.exist?.should be_true
end


