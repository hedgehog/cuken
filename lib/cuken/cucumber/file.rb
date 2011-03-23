load 'aruba/cucumber.rb' unless defined? ::Aruba
World(::Cuken::Api::File)

#
# Refactorings, yet to be submitted to Aruba:
#
Given /^the empty file "([^"]*)"$/ do |file_name|
  Given %Q{an empty file named "#{file_name}"}
end

Given /^the file "([^"]*)" with:$/ do |file_name, file_content|
  Given %Q{a file named "#{file_name}" with:}, file_content
end

Then /^the file "([^"]*)" exists$/ do |arg1|
  Then %Q{a file named \"#{arg1}\" should exist}
end

Then /^the file "([^"]*)" does not exist$/ do |arg1|
  Then %Q{a file named \"#{arg1}\" should not exist}
end

Then /^the directory "([^"]*)" exists$/ do |arg1|
  Then %Q{a directory named \"#{arg1}\" should exist}
end

Then /^the directory "([^"]*)" does not exist$/ do |arg1|
  Then %Q{a directory named \"#{arg1}\" should not exist}
end

Then /^the file "([^"]*)" contains "([^"]*)"$/ do |file, content|
  Then %Q{the file "#{file}" should contain "#{content}"}
end

Then /^the file "([^"]*)" contains exactly:$/ do |file, content|
  Then %Q{the file "#{file}" should contain exactly:}, content
end

Then /^these directories exist:$/ do |table|
  Then %Q{the following directories should exist:}, table
end

Then /^these directories do not exist:$/ do |table|
  Then %Q{the following directories should not exist:}, table
end

Then /^these files exist:$/ do |table|
  Then %Q{the following files should exist:}, table
end

Then /^these files do not exist:$/ do |table|
  Then %Q{the following files should exist:}, table
end

#
# Cuken specific
#
Given /^we record the a-mtime of "([^"]*)"$/ do |filename|
  record_amtimes(filename)
end

Then /^the directory "([^"]*)" has decimal mode "(\d+)"$/ do |dirname, expected_mode|
  check_modes(expected_mode, dirname)
end

Then /^the directory "([^"]*)" has octal mode "(\d+)"$/ do |dirname, expected_mode|
  check_modes(expected_mode, dirname, true)
end

Then /^the directory "([^"]*)" is owned by "([^"]*)"$/ do |dirname, owner|
  check_uid(dirname, owner)
end

Then /^the file "([^"]*)" is owned by "([^"]*)"$/ do |filename, owner|
  check_uid(filename, owner)
end

Then /^the (.)time of "([^"]*)" changes$/ do |time_type, filename|
  check_amtime_change(filename, time_type)
end

Then /^the file "([^"]*)" contains "([^"]*)" exactly "(\d+)" times$/ do |file, partial_content, times|
 check_file_content(file, partial_content, true, times)
end

Then /^the file "([^"]*)" does not contain "([^"]*)" exactly "(\d+)" times$/ do |file, partial_content, times|
 check_file_content(file, partial_content, false, times)
end

Then /^the file "([^"]*)" has octal mode "(\d+)"$/ do |filename, expected_mode|
  check_modes(expected_mode, filename, true)
end

Then /^the file "([^"]*)" has decimal mode "(\d+)"$/ do |filename, expected_mode|
  check_modes(expected_mode, filename)
end
