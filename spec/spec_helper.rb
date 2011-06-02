$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rspec'
require 'stringio'
require 'fakefs/safe'
require 'fakefs/spec_helpers'
require 'rvm'
require 'rr'
require 'chef/mixins'
require 'chef/knife/configure'
require 'chef/knife/client_create'

require 'cuken/api/rvm'
require 'cuken/api/chef'
require 'cuken/api/chef/knife'
require 'cuken/api/vagrant'
require 'cuken/api/aruba'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|

    config.mock_with :rr
    include ::Cuken::Api::Chef
    include ::Cuken::Api::Rvm
    include ::Cuken::Api::Rvm::Gemsets
    include ::Cuken::Api::Vagrant
    include ::Vagrant::TestHelpers

    # or if that doesn't work due to a version incompatibility
    # config.mock_with RR::Adapters::Rspec
end

def test_rvmrc(rubie, gemset_name)
%Q{
ruby_id="#{rubie}"
gemset_id="#{gemset_name}"
environment_id=${ruby_id}@${gemset_id}
if [[ -d "${rvm_path:-$HOME/.rvm}/environments" \
  && -s "${rvm_path:-$HOME/.rvm}/environments/$environment_id" ]] ; then
  \. "${rvm_path:-$HOME/.rvm}/environments/$environment_id"
else
  # If the environment file has not yet been created, use the RVM CLI to select.
  rvm --create  "$environment_id"
fi
filename=${gemset_id}.gems
if [[ -s "$filename" ]] ; then
  rvm gemset import "$filename" | grep -v already | grep -v listed | grep -v complete | sed '/^$/d'
fi
}
end

def test_gems
%Q{
# cuken.gems generated gem export file. Note that any env variable settings will be missing. Append these after using a ';' field separator
1 -v1.0.0
2 -v3.0.5
3 -v0.6.7
}
end

def setup_rvmrc_gems_files(count)
  root= FileUtils.mkpath("/path/to/dir", :mode => 0755)
  full="/path/to/dir/#{(1..count).to_a.join('/')}"
  FileUtils.mkpath(full, :mode => 0755)
  Pathname(full).ascend do |d|
    num = File.basename d
    File.open("#{d.to_s}/.rvmrc", "w") { |f| f << test_rvmrc("ruby-1.9.2-p136", num) }
    File.open("#{d.to_s}/#{num}.gems", "w") { |f| f << test_gems }
  end
  root.to_s
end
def test_vagrantfile(names=['web','db'])
%Q{
Vagrant::Config.run do |config|
  config.vm.define :#{names[0]} do |config|
    config.vm.box = "#{names[0]}"
    config.vm.forward_port("http", 80, 8080)
  end

  config.vm.define :#{names[1]} do |cnfg|
    cnfg.vm.box = "#{names[1]}"
    cnfg.vm.forward_port("#{names[1]}", 3306, 3306)
  end
end
}
end

class ::VagrantVMExampleHelpers
  include ::Cuken::Api::Aruba::Api
  include ::Cuken::Api::Vagrant::VM

   def self.create_vm_instance(name)
     new(name)
   end
end
