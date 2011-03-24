load 'aruba/cucumber.rb' unless defined? ::Aruba
require 'grit'

World(::Cuken::Api::Chef)

Before do
  @aruba_timeout_seconds.nil? || @aruba_timeout_seconds < 20 ? @aruba_timeout_seconds = 20 : @aruba_timeout_seconds
end

Before('@work_in_cwd') do
  @dirs = [Pathname.getwd.expand_path.realpath.to_s]
end

require 'cuken/cucumber/chef/common'
require 'cuken/cucumber/chef/knife'
require 'cuken/cucumber/chef/cookbook'
