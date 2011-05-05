########################################################################################################################
#
# Variation on Aruba's output steps
#
########################################################################################################################

Then /^the stderr contains "([^"]*)"$/ do |partial_output|
  all_stderr.should include(partial_output)
end

Then /^the stderr contains:$/ do |partial_output|
  all_stderr.should include(partial_output)
end

Then /^the stderr contains exactly:$/ do |exact_output|
  all_stderr.should == exact_output
end

Then /^the stderr does not contain "([^"]*)"$/ do |partial_output|
  all_stderr.should_not include(partial_output)
end

Then /^the stderr does not contain:$/ do |partial_output|
  all_stderr.should_not include(partial_output)
end

Then /^the stderr from "([^"]*)" contains "([^"]*)"$/ do |cmd, partial_output|
  stderr_from(cmd).should include(partial_output)
end

Then /^the stderr from "([^"]*)" does not contain "([^"]*)"$/ do |cmd, partial_output|
  stderr_from(cmd).should_not include(partial_output)
end
