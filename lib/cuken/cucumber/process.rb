World(::Cuken::Api::Process)

Then /^a process named "([^"]*)" is running$/ do |proc_name|
  check_process(proc_name)
end

Then /^a process named "([^"]*)" is not running$/ do |proc_name|
  check_process_not_running(proc_name)
end

Then /^a process named "([^"]*)" is running and owned by "([^"]*)"$/ do |proc_name,owner|
  check_process(proc_name,owner)
end

Then /^a process named "([^"]*)" is running with pid "([^"]*)"$/ do |proc_name,pid|
  check_process(proc_name,nil,pid)
end


Then /^these processes are running:$/ do |table|
  table_raw = table.raw
  if table_raw[0][0] == 'name'
    table_raw.delete_at(0)
  end
  table_raw.map{|row| check_process(row[0],row[1],row[2])}
end
