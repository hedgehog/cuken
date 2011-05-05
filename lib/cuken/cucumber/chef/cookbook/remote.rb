Then /^these remote Cookbooks exist:$/ do |table|
  check_remote_cookbook_table_presence(table)
end

Then /^these remote Cookbooks do not exist:$/ do |table|
  check_remote_cookbook_table_presence(table, false)
end

Given /^the remote Cookbook repository "([^"]*)"$/ do |ckbk_repo|
  in_dir do
    repo = Dir.exist?(ckbk_repo) ? Pathname(ckbk_repo).expand_path.realdirpath : ckbk_repo
    chef.remote_cookbook_repo = repo
  end
end

Given /^the remote Cookbooks URI "([^"]*)"$/ do |ckbk_uri|
  in_dir do
    repo = Dir.exist?(ckbk_uri) ? Pathname(ckbk_uri).expand_path.realdirpath : ckbk_uri
    chef.cookbooks_uri = repo
  end
end
