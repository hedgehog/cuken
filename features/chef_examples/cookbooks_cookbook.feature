@announce @work_in_cwd @cookbooks @cookbook_validity
Feature: Cookbook Validity
  In order to understand cookbooks without evaluating them
  As an Administrator
  I want to automatically confirm cookbook existence and validity

  Background:
    Given a default base Chef repository in "ckbk/scratch/myapp"

  Scenario: Clone from a Cookbook repository
    Given the remote Cookbook repository "features/data/repositories/cookbooks/hosts/.git"
     When I clone the remote Cookbook repository branch "master" to "ckbk/scratch/myapp/cookbooks/hosts"
     Then the local Cookbook repository exists
      And the local Cookbook "hosts" exists

  Scenario: Clone a single Cookbook from a Cookbooks URI
    Given the remote Cookbooks URI "git://github.com/cookbooks/"
     When I clone the Cookbook "hosts" branch "master" to "ckbk/scratch/myapp/cookbooks/hosts2"
     Then the local Cookbook repository exists
      And the local Cookbook "hosts" exists

  Scenario: Clone multiple Cookbooks from a Cookbooks URI
    Given the remote Cookbooks URI "git://github.com/cookbooks/"
     When I clone the Cookbooks:
     |cookbook | branch | destination                         |
     | hosts   | master | ckbk/scratch/myapp/cookbooks/hosts3 |
     | users   | master | ckbk/scratch/myapp/cookbooks/users  |
      And these local Cookbooks exist:
     |cookbook |
     | hosts3  |
     | users   |

