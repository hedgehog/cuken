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
Given /^the Gem "([^\"]*)" has been required$/ do |gem|
  Gem.loaded_specs.key?(gem).should be_true
end

Given /^that "([^\"]*)" has been required$/ do |lib|
  require(lib).should be_false
end

Then /^these steps are defined for "([^\"]*)":$/ do |file, table|
  rsc = ::Cucumber::Runtime::SupportCode.new 'ui', :autoload_code_paths => 'lib/cuken/cucumber'
  rsc.load_files! ["lib/#{file}", "#{ENV['GEM_HOME']}/gems/aruba-0.3.6/lib/aruba/cucumber.rb"]
  sd_array = rsc.step_definitions
  #sd_array.each{|sd| puts sd.regexp_source}
  table.hashes.each do |hsh|
    sd_array.each{|sd| res = sd.regexp_source == %Q{/^#{hsh['step']}$/}; break('found') if res}.should == 'found'
  end
end

When /^I do aruba (.*)$/ do |aruba_step|
  begin
    When(aruba_step)
  rescue => e
    @aruba_exception = e
  end
end

Then /^I see aruba (.*)$/ do |aruba_step|
  begin
    Then(aruba_step)
  rescue => e
    @aruba_exception = e
  end
end

