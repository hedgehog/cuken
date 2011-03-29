load 'aruba/cucumber.rb' unless defined? ::Aruba

World(::Cuken::Api::Cmd)

#
# These ought be submitted to Aruba...
#
Then /^the output from "(.*)" contains exactly:$/ do |cmd, exact_output|
  output_from(unescape(cmd)).should == exact_output
end
Then /^the output from "([^"]*)" does not contain exactly:$/ do |cmd, exact_output|
  output_from(unescape(cmd)).should_not == exact_output
end
Then /^the output from "([^"]*)" contains:$/ do |cmd, partial_output|
  output_from(unescape(cmd)).should =~ regexp(partial_output)
end
Then /^the output from "([^"]*)" does not contain:$/ do |cmd, partial_output|
  output_from(unescape(cmd)).should_not =~ regexp(partial_output)
end

