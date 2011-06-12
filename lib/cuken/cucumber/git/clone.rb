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
World(::Cuken::Api::Git)

Given /^I clone the remote Git repository branch "([^"]*)" to "([^"]*)"$/ do |brnch, repo_path|
  git.local_git_repo = git_clone_repo(repo_path, git.remote_git_repo, {'branch' => brnch})
end

Given /^I clone the Repository "([^"]*)" branch "([^"]*)" to "([^"]*)"$/ do |repo, brnch, repo_path|
    git.local_git_repo = git_clone_repo(repo_path, git.git_uri + repo + '.git', {'branch' => brnch})
end

When /^I clone the Repositories:$/ do |table|
  table.hashes.each do |hsh|
    src = {}
    src['branch'] = hsh['branch'] if hsh['branch']
    src['tag'] = hsh['tag'] if hsh['tag']
    src['ref'] = hsh['ref'] if hsh['ref']
    repo = hsh['repo'] if hsh['repo']
    repo = hsh['repository'] if hsh['repository']
    local_repo = git_clone_repo(hsh['destination'], git.git_uri + repo + '.git', src )
    Pathname(local_repo).exist?.should be_true
  end
end

