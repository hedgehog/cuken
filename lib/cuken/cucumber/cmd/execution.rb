#
World(::Cuken::Api::Aruba::Api)

When /^I run `([^`]*)`$/ do |cmd|
  run_simple(unescape(cmd), current_dir, false)
end

When /^I run `([^`]*)` in "([^"]*)"$/ do |cmd, dir|
  run_simple(unescape(cmd), dir, false)
end

When /^I successfully run `([^`]*)`$/ do |cmd|
  run_simple(unescape(cmd))
end

When /^I successfully run `([^`]*)` in "([^"]*)"$/ do |cmd, dir|
  run_simple(unescape(cmd), dir)
end

When /^I interactively run `([^`]*)`$/ do |cmd|
  run_interactive(unescape(cmd))
end

When /^I interactively run `([^`]*)` in "([^"]*)"$/ do |cmd, dir|
  run_interactive(unescape(cmd), dir)
end

When /^I type "([^"]*)"$/ do |input|
  type(input)
end

And /^I set the environment variable "([^"]*)" to "([^"]*)"$/ do |variable, value|
  ENV[variable] = value
end