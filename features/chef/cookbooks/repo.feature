@announce @work_in_cwd @cookbooks @chef_repo
Feature: Base Chef repository for cookbooks
  In order to have a Chef skeleton to build a custom deployment
  As an Administrator
  I want to automatically clone a generic base Chef repository

  Background:
      Given a directory named "ckbk/scratch"

  Scenario: Clone a Chef skeleton repository
      And the remote chef repository "features/data/repositories/chef-repo/.git"
     When I clone the remote chef repository branch "master" to "tmp/aruba/ckbk/scratch/myapp"
     Then the local chef repository exists
