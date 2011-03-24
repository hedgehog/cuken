@cookbooks @cookbook_validity
Feature: Cookbook Validity
  In order to understand cookbooks without evaluating them
  As an Administrator
  I want to automatically confirm cookbook existence and validity

  Background:
    Given a default base chef repository in "ckbk/scratch/myapp"

  Scenario: Clone a cookbook repository
    Given I cd to "./../../"
      And the remote cookbook repository "features/data/repositories/cookbooks/hosts/.git"
     When I clone the remote cookbook repository branch "master" to "tmp/aruba/ckbk/scratch/myapp/cookbooks/hosts"
     Then the local cookbook repository exists
      And the local cookbook "hosts" exists
