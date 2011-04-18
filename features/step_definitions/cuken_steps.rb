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

