require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rspec/expectations'

$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../../lib')
require 'cuken/ssh'
require 'cuken/cmd'
require 'cuken/file'
require 'cuken/chef'
require 'cuken/vagrant'
require 'cuken/git'

