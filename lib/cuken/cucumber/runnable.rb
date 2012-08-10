World(::Cuken::Api::Runnable)

Then /^the file at "([^"]*)" is executable$/ do |file|
  check_executable_by_executors(file)
end

Then /^the file at "([^"]*)" is a setuid executable$/ do |file|
  check_setuid(file)
end

Then /^the file at "([^"]*)" is a setgid executable$/ do |file|
  check_setgid(file)
end

Then /^the file at "([^"]*)" is executable by ([ugo]{1,3})$/ do |file,executors|
  check_executable_by_executors(file,executors)
end

Then /^the file at "([^"]*)" is executable by "([^"]*)"$/ do |file,user|
  check_executable_by_user(file,user)
end

Then /^these executables exist:$/ do |table|
  check_executables(table.hashes)
end

Then /^the command "([^"]*)" yields "(.*)"$/ do |command,response|
  check_response(command,response)
end

Then /^the command "([^"]*)" yields a response containing "(.*)"$/ do |command,response|
  check_response(command,response,true)
end

Then /^these executables respond properly:$/ do |table|
  table_raw = table.raw
  contains = table_raw[0][1] == 'response contains'
  table_raw.delete_at(0) if table_raw[0][0] == 'command'
  table_raw.map{|row| check_response(row[0],row[1],contains)}
end
