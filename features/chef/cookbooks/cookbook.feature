@announce @work_in_cwd @cookbooks @cookbook_validity
Feature: Cookbook Validity
  In order to understand cookbooks without evaluating them
  As an Administrator
  I want to automatically confirm cookbook existence and validity

  Background:
    Given a default base Chef repository in "ckbk/scratch/myapp"

  Scenario: Clone a cookbook repository
      And the remote Cookbook repository "features/data/repositories/cookbooks/hosts/.git"
     When I clone the remote Cookbook repository branch "master" to "ckbk/scratch/myapp/cookbooks/hosts"
     Then the local Cookbook repository exists
      And the local cookbook "hosts" exists
