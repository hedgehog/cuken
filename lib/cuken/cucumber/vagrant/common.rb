#
# Author:: Hedgehog (<hedgehogshiatus@gmail.com>)
# Copyright:: Copyright (c) 2011 Hedgehog.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
World(::Cuken::Api::Vagrant)

########################################################################################################################
#
# Generic (Given, When or Then)
#
########################################################################################################################

########################################################################################################################
#
# Given
#
########################################################################################################################

########################################################################################################################
#
# When
#
########################################################################################################################

########################################################################################################################
#
# Then
#
########################################################################################################################
puts 'what is here...'
And /^I switch Vagrant environment$/ do
  switch_vagrant_environment
end

And /^the state of VM "([^"]*)" is "([^"]*)"$/ do |name, state|
  check_vm_state(name, state.to_sym)
end

And /^the state of VM "([^"]*)" is not "([^"]*)"$/ do |name, state|
  check_vm_state(name, state.to_sym, false)
end

When /^I ssh to VM "([^\"]*)"$/ do |boxname|
  establish_vm_interactive_ssh(boxname)
end

And /^the Vagrantfile "([^\"]*)" exists$/ do |path|
  check_vagrant_file_presence(path)
end

And /^the Vagrantfile "([^\"]*)" does not exist$/ do |path|
  check_vagrant_file_presence(path, false)
end

When /^I launch the VM "([^"]*)"$/ do |vm_name|
  run_vm_manager_command(:up, vm_name)
end

When /^I halt the VM "([^"]*)"$/ do |vm_name|
  run_vm_manager_command(:halt, vm_name)
end

When /^I destroy the VM "([^"]*)"$/ do |vm_name|
  run_vm_manager_command(:destroy, vm_name)
end

When /^I provision the VM "([^"]*)"$/ do |vm_name|
  run_vm_manager_command(:provision, vm_name)
end

When /^I suspend the VM "([^"]*)"$/ do |vm_name|
  run_vm_manager_command(:suspend, vm_name)
end

When /^I resume the VM "([^"]*)"$/ do |vm_name|
  run_vm_manager_command(:resume, vm_name)
end

When /^I reload the VM "([^"]*)"$/ do |vm_name|
  run_vm_manager_command(:reload, vm_name)
end

puts 'do we get here??'