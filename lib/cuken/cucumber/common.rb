
And /^wait "([^"]*)" seconds$/ do |delay|
    ::Kernel.sleep(delay.to_f)
end

Given /^the working directory is "([^"]*)"$/ do |path|
  @dirs = [path]
end