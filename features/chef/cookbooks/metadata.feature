@announce @work_in_cwd @cookbooks @cookbook_metadata
Feature: Cookbook Metadata
  In order to understand cookbooks without evaluating them
  As an Administrator
  I want to automatically generate metadata about cookbooks

  Background:
    Given a default base chef repository in "ckbk/scratch/myapp"
      And the local chef repository exists
      And a file named "ckbk/scratch/myapp/.chef/knife.rb" with:
      """
      current_dir = File.dirname(__FILE__)
      log_level :debug
      log_location $stdout
      node_name "bobo"
      client_key "#{File.dirname(current_dir)}/bobo.pem"
      chef_server_url "http://localhost:4000"
      cache_type 'Memory'
      cache_options( :path => "#{ENV['HOME']}/.chef/checksums" )
      cookbook_path ["#{current_dir}/../cookbooks","#{current_dir}/../site-cookbooks"]

      """
      And the remote cookbook repository "features/data/repositories/cookbooks/hosts/.git"
      And I clone the remote cookbook repository branch "master" to "ckbk/scratch/myapp/cookbooks/hosts"
      And the local cookbook repository exists

  Scenario: Generate metadata for all cookbooks
     When I successfully generate all cookbook metadata
      And the output should contain "DEBUG: Generated "
      And the output should not contain "DEBUG: No "
    Then the file "ckbk/scratch/myapp/cookbooks/hosts/metadata.json" exists

  Scenario: Generate metadata for a specific cookbook
     When we record the a-mtime of "ckbk/scratch/myapp/cookbooks/hosts/metadata.json"
      And I successfully generate cookbook "hosts" metadata
      And the output should contain "DEBUG: Generated "
      And the output should not contain "DEBUG: No "
    Then the file "ckbk/scratch/myapp/cookbooks/hosts/metadata.json" exists
      And the mtime of "ckbk/scratch/myapp/cookbooks/hosts/metadata.json" changes
