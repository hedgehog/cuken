###
# Then
###
Then /^the roles are:$/ do |partial_output|
  run_knife_command('role list')
  all_stdout.should include(partial_output)
end
