Given /^the Knife file "([^"]*)"$/ do |path|
  in_current_dir do
    chef.client_knife_path = Pathname(path).expand_path.realdirpath
  end
end

When /^I successfully run Knife's "([^"]*)"$/ do |cmd|
  in_current_dir do
    cmd += " -c #{chef.client_knife_path.expand_path.to_s}" if chef.client_knife_path && chef.client_knife_path.expand_path.exist?
    cmd += " -o #{(chef.cookbook_paths.collect{|pn|pn.expand_path.to_s}).join(':')}" unless chef.cookbook_paths.empty?
    cmd += " --log_level debug" if chef.knife_debug
    run_simple(unescape("knife " + cmd))
  end
end

When /^I interactively run Knife's "([^"]*)"$/ do |cmd|
  in_current_dir do
    cmd += " -c #{chef.client_knife_path.expand_path.to_s}" if chef.client_knife_path && chef.client_knife_path.expand_path.exist?
    cmd += " -o #{(chef.cookbook_paths.collect{|pn|pn.expand_path.to_s}).join(':')}" unless chef.cookbook_paths.empty?
    cmd += " --log_level debug" if chef.knife_debug
    run_interactive(unescape("knife " + cmd))
  end
end
