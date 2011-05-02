#
# Author:: Hedgehog (<hedgehogshiatus@gmail.com>)
# Copyright:: Copyright (c) 2011 Hedgehog.
# Portions of this work are derived from the Chef project
# The original license header follows:
#
# Author:: Adam Jacob (<adam@opscode.com>)
# Author:: Christopher Walters (<cw@opscode.com>)
# Author:: Tim Hinderliter (<tim@opscode.com>)
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
World(::Cuken::Api::Chef::Cookbook)

Given /^the remote Cookbook repository "([^"]*)"$/ do |ckbk_repo|
  in_current_dir do
    repo = Dir.exist?(ckbk_repo) ? Pathname(ckbk_repo).expand_path.realdirpath : ckbk_repo
    chef.remote_cookbook_repo = repo
  end
end

Given /^the remote Cookbooks URI "([^"]*)"$/ do |ckbk_uri|
  in_current_dir do
    repo = Dir.exist?(ckbk_uri) ? Pathname(ckbk_uri).expand_path.realdirpath : ckbk_uri
    chef.cookbooks_uri = repo
  end
end

Given /^the local Cookbook repository "([^"]*)"$/ do |ckbk_repo|
  in_current_dir do
    repo = Dir.exist?(ckbk_repo) ? Pathname(ckbk_repo).expand_path.realdirpath : ckbk_repo
    chef.local_cookbook_repo = repo
  end
end

Then /^the local Cookbook repository exists$/ do
  chef.local_cookbook_repo.exist?.should be_true
  #TODO: check_file_presence([file], true), etc.
end

Then /^the local Site\-Cookbook repository exists$/ do
  chef.local_site_cookbook_repo.exist?.should be_true
  #TODO: check_file_presence([file], true), etc.
end

Given /^a Cookbook path "([^"]*)"$/ do |dir_name|
  create_dir(dir_name)
  in_current_dir do
    update_cookbook_paths(dir_name, true)
  end
end

Given /^a Cookbooks path "([^"]*)"$/ do |dir_name|
  create_dir(dir_name)
  in_current_dir do
    update_cookbook_paths(dir_name, false)
  end
end

Then /^the local Cookbook "([^"]*)" exists$/ do |ckbk|
  chef.cookbook_paths.each do |pn|
    curr_ckbk = pn.basename.to_s
    if curr_ckbk == ckbk
      break true if curr_ckbk.should == ckbk
    end
  end
  #TODO: check_file_presence([file], true), etc.
end

Then /^the local Site\-Cookbook "([^"]*)" exists$/ do |ckbk|
  ckbk_path = 'site-cookbook'
  chef.cookbook_paths.each do |pn|
    curr_ckbk = pn.basename.to_s
    if pn.to_s[/#{ckbk_path}}/] && curr_ckbk == ckbk
      break true if curr_ckbk.should == ckbk
    end
  end
  #TODO: check_file_presence([file], true), etc.
end

And /^these local Cookbooks exist:$/ do |table|
  check_cookbooks_table_presence(table)
end

And /^these local Site\-Cookbooks exist:$/ do |table|
  # table is a Cucumber::Ast::Table
  ckbk_path = 'site-cookbook'
  table.hashes.each do |hsh|
    chef.cookbook_paths.each do |pn|
      curr_ckbk = pn.basename.to_s
      if pn.to_s[/#{ckbk_path}}/] && curr_ckbk == hsh['cookbook']
        break true if curr_ckbk.should == hsh['cookbook']
      end
    end
  end
end

Given /^I clone the remote Cookbook repository branch "([^"]*)" to "([^"]*)"$/ do |brnch, ckbk_path|
  if ckbk_path[/\/cookbooks\//]
    chef.local_cookbook_repo = chef_clone_repo(ckbk_path, true, chef.remote_cookbook_repo, {'branch' => brnch})
  elsif ckbk_path[/\/site-cookbooks\//]
    chef.local_site_cookbook_repo = chef_clone_repo(ckbk_path, true, chef.remote_cookbook_repo, {'branch' => brnch})
  end
end

Given /^I clone the Cookbook "([^"]*)" branch "([^"]*)" to "([^"]*)"$/ do |ckbk, brnch, ckbk_path|
  if ckbk_path[/\/cookbooks\//]
    chef.local_cookbook_repo = chef_clone_repo(ckbk_path, true, chef.cookbooks_uri + ckbk + '.git', {'branch' => brnch})
  elsif ckbk_path[/\/site-cookbooks\//]
    chef.local_site_cookbook_repo = chef_clone_repo(ckbk_path, true, chef.cookbooks_uri + ckbk + '.git', {'branch' => brnch})
  end
end

When /^I clone the Cookbooks:$/ do |table|
  table.hashes.each do |hsh|
    src = {}
    src['branch'] = hsh['branch'] if hsh['branch']
    src['tag'] = hsh['tag'] if hsh['tag']
    src['ref'] = hsh['ref'] if hsh['ref']
    local_repo = chef_clone_repo(hsh['destination'], true, chef.cookbooks_uri + hsh['cookbook'] + '.git', src )
    Pathname(local_repo).exist?.should be_true
  end
end

When /^I successfully generate all Cookbook metadata$/ do
  chef.cookbook_paths.each do |pn|
    curr_ckbk = pn.basename.to_s
    run_knife_command("cookbook metadata #{curr_ckbk}")
  end
end

When /^I successfully generate Cookbook "([^"]*)" metadata$/ do |ckbk|
  chef.cookbook_paths.each do |pn|
    curr_ckbk = pn.basename.to_s
    if curr_ckbk == ckbk
      run_knife_command("cookbook metadata #{curr_ckbk}")
    end
  end
end
