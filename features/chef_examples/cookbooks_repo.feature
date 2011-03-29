@announce @cookbooks @chef_repo
Feature: Clone local Chef repository for cookbooks
  In order to have a Chef skeleton to build a custom deployment
  As an Administrator
  I want to automatically clone a generic base Chef repository

  Background:
      Given a directory named "ckbk/scratch"

  Scenario: Clone a local Chef skeleton repository
      And the remote Chef repository "./../../features/data/repositories/chef-repo/.git"
     When I clone the remote Chef repository branch "master" to "ckbk/scratch/myapp"
     Then the local Chef repository exists
