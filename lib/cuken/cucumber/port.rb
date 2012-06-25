World(::Cuken::Api::Port)

Then /^the port "([^"]*)" is open$/ do |port|
  check_port_status([port],true)
end

Then /^the port "([^"]*)" is not open$/ do |port|
  check_port_status([port],false)
end

Then /^the port "([^"]*)" is open on host "([^"]*)"$/ do |port,host|
  check_port_status([port],true,host)
end

Then /^the port "([^"]*)" is not open on host "([^"]*)"$/ do |port,host|
  check_port_status([port],false,host)
end


Then /^these ports are open:$/ do |table|
  table.hashes.each do |hash|
    hash['host'] = 'localhost' unless hash.has_key?('host')
    check_port_status([hash['port']],true,hash['host'])
  end
end

Then /^these ports are not open:$/ do |table|
  table.hashes.each do |hash|
    hash['host'] = 'localhost' unless hash.has_key?('host')
    check_port_status([hash['port']],false,hash['host'])
  end
end
