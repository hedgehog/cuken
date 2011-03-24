load 'aruba/cucumber.rb' unless defined? ::Aruba
require 'grit'

World(::Cuken::Api::Chef)

Before do
  @aruba_timeout_seconds.nil? || @aruba_timeout_seconds < 20 ? @aruba_timeout_seconds = 20 : @aruba_timeout_seconds
end

require 'cuken/cucumber/chef/common'
require 'cuken/cucumber/chef/knife'
require 'cuken/cucumber/chef/cookbook'
