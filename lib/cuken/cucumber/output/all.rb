########################################################################################################################
#
# Variation on Aruba's output steps
#
########################################################################################################################

Then /^the output contains "([^"]*)"$/ do |partial_output|
  assert_partial_output(partial_output)
end

Then /^the output does not contain "([^"]*)"$/ do |partial_output|
  all_output.should_not include(partial_output)
end

Then /^the output contains:$/ do |partial_output|
  all_output.should include(partial_output)
end

Then /^the output does not contain:$/ do |partial_output|
  all_output.should_not include(partial_output)
end

Then /^the output contains exactly "([^"]*)"$/ do |exact_output|
  all_output.should == exact_output
end

Then /^the output contains exactly:$/ do |exact_output|
  all_output.should == exact_output
end

# "the output matches" allows regex in the partial_output, if
# you don't need regex, use "the output contains" instead since
# that way, you don't have to escape regex characters that
# appear naturally in the output
Then /^the output matches \/([^\/]*)\/$/ do |partial_output|
  all_output.should =~ /#{partial_output}/
end

Then /^the output matches:$/ do |partial_output|
  all_output.should =~ /#{partial_output}/m
end
