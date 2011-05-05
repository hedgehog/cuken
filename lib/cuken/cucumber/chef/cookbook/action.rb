
When /^I load the Cookbooks:$/ do |table|
  cookbooks_load(table)
end

Given /^I clone the remote Cookbook repository branch "([^"]*)" to "([^"]*)"$/ do |brnch, ckbk_path|
  if ckbk_path[/\/cookbooks\//]
    chef.local_cookbook_repo = chef_clone_repo(ckbk_path, true, chef.remote_cookbook_repo, {'branch' => brnch})
  elsif ckbk_path[/\/site-cookbooks\//]
    chef.local_site_cookbook_repo = chef_clone_repo(ckbk_path, true, chef.remote_cookbook_repo, {'branch' => brnch})
  end
end

Given /^I clone the Cookbook "([^"]*)" branch "([^"]*)" to "([^"]*)"$/ do |ckbk, brnch, ckbk_path|
  if ckbk_path[/\/cookbooks\//]
    chef.local_cookbook_repo = chef_clone_repo(ckbk_path, true, chef.cookbooks_uri + ckbk + '.git', {'branch' => brnch})
  elsif ckbk_path[/\/site-cookbooks\//]
    chef.local_site_cookbook_repo = chef_clone_repo(ckbk_path, true, chef.cookbooks_uri + ckbk + '.git', {'branch' => brnch})
  end
end

When /^I clone the Cookbooks:$/ do |table|
  table.hashes.each do |hsh|
    src = {}
    src['branch'] = hsh['branch'] if hsh['branch']
    src['tag'] = hsh['tag'] if hsh['tag']
    src['ref'] = hsh['ref'] if hsh['ref']
    ckbk = hsh['cookbook'] if hsh['cookbook']
    ckbk = hsh['site-cookbook'] if hsh['site-cookbook']
    local_repo = chef_clone_repo(hsh['destination'], true, chef.cookbooks_uri + ckbk + '.git', src )
    Pathname(local_repo).exist?.should be_true
  end
end

When /^I successfully generate all Cookbook metadata$/ do
  chef.cookbook_paths.each do |pn|
    curr_ckbk = pn.basename.to_s
    run_knife_command("cookbook metadata #{curr_ckbk}")
  end
end

When /^I successfully generate Cookbook "([^"]*)" metadata$/ do |ckbk|
  chef.cookbook_paths.each do |pn|
    curr_ckbk = pn.basename.to_s
    if curr_ckbk == ckbk
      run_knife_command("cookbook metadata #{curr_ckbk}")
    end
  end
end
