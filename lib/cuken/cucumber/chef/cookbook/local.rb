Given /^a Cookbook path "([^"]*)"$/ do |dir_name|
  create_dir(dir_name)
  in_dir do
    update_cookbook_paths(dir_name, true)
  end
end

Given /^a Cookbooks path "([^"]*)"$/ do |dir_name|
  create_dir(dir_name)
  in_dir do
    update_cookbook_paths(dir_name, false)
  end
end

Then /^the local Cookbook "([^"]*)" exists$/ do |ckbk|
  chef.cookbook_paths.each do |pn|
    curr_ckbk = pn.basename.to_s
    if curr_ckbk == ckbk
      break true if curr_ckbk.should == ckbk
    end
  end
  #TODO: check_file_presence([file], true), etc.
end

Given /^the local Cookbook repository "([^"]*)"$/ do |ckbk_repo|
  in_dir do
    repo = Dir.exist?(ckbk_repo) ? Pathname(ckbk_repo).expand_path.realdirpath : ckbk_repo
    chef.local_cookbook_repo = repo
  end
end

Then /^the local Cookbook repository exists$/ do
  chef.local_cookbook_repo.exist?.should be_true
  #TODO: check_file_presence([file], true), etc.
end

Then /^the local Site\-Cookbook "([^"]*)" exists$/ do |ckbk|
  ckbk_path = 'site-cookbook'
  chef.cookbook_paths.each do |pn|
    curr_ckbk = pn.basename.to_s
    if pn.to_s[/#{ckbk_path}}/] && curr_ckbk == ckbk
      break true if curr_ckbk.should == ckbk
    end
  end
  #TODO: check_file_presence([file], true), etc.
end

Then /^the local Site\-Cookbook repository exists$/ do
  chef.local_site_cookbook_repo.exist?.should be_true
  #TODO: check_file_presence([file], true), etc.
end

And /^these local Cookbooks exist:$/ do |table|
  check_cookbook_table_presence(table)
end

And /^these local Cookbooks do not exist:$/ do |table|
  check_cookbook_table_presence(table, false)
end

And /^these local Site\-Cookbooks exist:$/ do |table|
  ckbk_path = 'site-cookbook'
  table.hashes.each do |hsh|
    chef.cookbook_paths.each do |pn|
      curr_ckbk = pn.basename.to_s
      if pn.to_s[/#{ckbk_path}}/] && curr_ckbk == hsh['cookbook']
        break true if curr_ckbk.should == hsh['cookbook']
      end
    end
  end
end
