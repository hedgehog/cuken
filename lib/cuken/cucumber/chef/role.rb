###
# Given
###

###
# When
###
When /^I load the Cookbook Roles:$/ do |table|
  # table is a Cucumber::Ast::Table
  pending # express the regexp above with the code you wish you had
end

###
# Then
###
Then /^the Roles are:$/ do |partial_output|
  run_knife_command('role list')
  all_stdout.should include(partial_output)
end

Then /^these Roles exist:$/ do |table|
  run_knife_command('role list')
  pending # express the regexp above with the code you wish you had
end
