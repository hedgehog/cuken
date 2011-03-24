Given /^the Knife file "([^"]*)"$/ do |path|
  in_current_dir do
    chef.client_knife_path = Pathname(path).expand_path.realdirpath
  end
end

When /^I successfully run Knife's "([^"]*)"$/ do |cmd|
  run_knife_command(cmd, true)
end

When /^I interactively run Knife's "([^"]*)"$/ do |cmd|
  run_knife_command(cmd, true)
end
