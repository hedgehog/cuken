########################################################################################################################
#
# Variation on Aruba's output steps
#
########################################################################################################################

Then /^the stdout contains "([^"]*)"$/ do |partial_output|
  all_stdout.should include(partial_output)
end

Then /^the stdout contains:$/ do |partial_output|
  all_stdout.should include(partial_output)
end

Then /^the stdout contains exactly:$/ do |exact_output|
  all_stdout.should == exact_output
end

Then /^the stdout does not contain "([^"]*)"$/ do |partial_output|
  all_stdout.should_not include(partial_output)
end

Then /^the stdout does not contain:$/ do |partial_output|
  all_stdout.should_not include(partial_output)
end

Then /^the stdout from "([^"]*)" contains "([^"]*)"$/ do |cmd, partial_output|
  stdout_from(cmd).should include(partial_output)
end

Then /^the stdout from "([^"]*)" does not contain "([^"]*)"$/ do |cmd, partial_output|
  stdout_from(cmd).should_not include(partial_output)
end

