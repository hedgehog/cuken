
Given /^Assumption: (.*)$/ do |msg|
  announce_or_puts(msg)
end

Given /^Explanation: (.*)$/ do |msg|
  announce_or_puts(msg)
end

Given /^Instruction: (.*)$/ do |msg|
  announce_or_puts(msg)
end

And /^wait "([^"]*)" seconds$/ do |delay|
    ::Kernel.sleep(delay.to_f)
end

Given /^the working directory is "([^"]*)"$/ do |path|
  @dirs = [path]
end