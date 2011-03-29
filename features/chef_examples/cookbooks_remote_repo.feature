@announce @cookbooks @chef_repo
Feature: Clone remote Chef repository for cookbooks
  In order to have a Chef skeleton to build a custom deployment
  As an Administrator
  I want to automatically clone a generic base Chef repository

  Scenario: Clone a remote Chef skeleton repository
      And the remote Chef repository "git://github.com/opscode/chef-repo.git"
     When I clone the remote Chef repository branch "master" to "myapp"
     Then the local Chef repository exists
