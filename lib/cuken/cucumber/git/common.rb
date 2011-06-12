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

Given /^a default Git repository in "([^"]*)"$/ do |path|
  git.local_git_repo = git_clone_repo(path)
  git.local_git_repo.exist?.should be_true
end

Given /^the remote Git repository "([^"]*)"$/ do |git_repo|
  in_dir do
    repo = Dir.exist?(git_repo) ? Pathname(git_repo).expand_path.realdirpath : git_repo
    git.remote_git_repo = repo
  end
end

Then /^the local Git repository exists$/ do
  git.local_git_repo.exist?.should be_true
  #TODO: check_file_presence([file], true), etc.
end


