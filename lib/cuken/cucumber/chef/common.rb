World(::Cuken::Api::Chef)

Before do
  @aruba_timeout_seconds.nil? || @aruba_timeout_seconds < 3 ? @aruba_timeout_seconds = 3 : @aruba_timeout_seconds
end

Given /^the Chef server URI "([^"]*)"$/ do |uri|
  chef.uri = uri
end

Given /^the Chef client "([^"]*)"$/ do |name|
  chef.client_name =  name
end

Given /^the Chef admin client "([^"]*)"$/ do |name|
  chef.admin_client_name =  name
end

Given /^the Chef client private key path "([^"]*)"$/ do |path|
  in_current_dir do
    chef.client_private_key_path = Pathname(path)
  end
end

Given /^the remote chef repository "([^"]*)"$/ do |chf_pth|
  in_current_dir do
    chef.remote_chef_repo = Pathname(chf_pth).expand_path.realdirpath
  end
end

Given /^the local chef repository "([^"]*)"$/ do |chf_pth|
  in_current_dir do
    chef.local_chef_repo = Pathname(chf_pth).expand_path.realdirpath
  end
end

Then /^the local chef repository exists$/ do
  chef.local_chef_repo.exist?.should be_true
  #TODO: check_file_presence([file], true), etc.
end

Given /^I clone the remote chef repository branch "([^"]*)" to "([^"]*)"$/ do |brnch, path|
  chef.local_chef_repo = chef_clone_repo(path, false, chef.remote_chef_repo, brnch)
end

Given /^a default base chef repository in "([^"]*)"$/ do |path|
  chef.local_chef_repo = chef_clone_repo(path)
end


