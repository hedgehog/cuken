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

Given /^a cookbook path "([^"]*)"$/ do |path|
  in_current_dir do
    chef.cookbook_paths << Pathname(path).expand_path.realdirpath
  end
end


