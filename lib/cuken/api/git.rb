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
require 'grit' unless defined? ::Grit
require 'cuken/api/common'
require 'cuken/api/git/common'
require 'cuken/api/git/clone'
require 'cuken/api/git/remote'

module ::Cuken
  module Api
    module Git

      include ::Cuken::Api::Git::Common
      include ::Cuken::Api::Git::Clone
      include ::Cuken::Api::Aruba::Api

      #TODO: Refactor with chef_clone_repo method
      def git_clone_repo(repo_path, repo = git.remote_git_repo, type = {'branch' => 'master'})
        in_dir do
          pth = Pathname(repo_path).expand_path
          gritty = ::Grit::Git.new((pth + '.git').to_s)
          announce_or_puts gritty.inspect
          clone_opts = {:depth => 1, :quiet => false, :verbose => true, :progress => true}
          type['branch'] = type['branch'].nil? ? '' : type['branch']
          type['tag'] = type['tag'].nil? ? '' : type['tag']
          type['ref'] = type['ref'].nil? ? '' : type['ref']
          if pth.directory?
            announce_or_puts "Pulling: #{repo} into #{pth}"
            FileUtils.cd(pth.to_s) do
              res = gritty.pull(clone_opts, repo)
            end
            clone_opts[:branch] = type['branch'].empty? ? 'master' : type['branch']
          else
            clone_opts[:branch] = type['branch'].empty? ? 'master' : type['branch']
            announce_or_puts "Cloning: #{repo} into #{pth}"
            res = gritty.clone(clone_opts, repo, pth.to_s)
          end
          clone_pull_error_check(res) if res
          grotty = ::Grit::Git.new((pth + '.git').to_s)
          grotty.checkout( { :B => clone_opts[:branch]||'master' } )
          if !type['tag'].empty? || !type['ref'].empty?
            grotty.checkout( { :B => true }, 'cuken', type['tag']||type['ref'] )
          else
            grotty.checkout( { :B => true }, 'cuken' )
          end
          pth
        end
      end

    end
  end
end
