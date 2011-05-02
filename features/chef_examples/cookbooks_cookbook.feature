@announce @cookbooks @cookbook_validity
Feature: Cookbook Validity
  In order to understand cookbooks without evaluating them
  As an Administrator
  I want to automatically confirm cookbook existence and validity

  Background:
    Given a default base Chef repository in "ckbk/scratch/myapp"

  Scenario: Clone from a Cookbook repository
    Given Explanation: Next we step up two levels to escape Aruba's working folder
      And the remote Cookbook repository "./../../features/data/repositories/cookbooks/hosts/.git"
     When I clone the remote Cookbook repository branch "master" to "ckbk/scratch/myapp/cookbooks/hosts"
     Then the local Cookbook repository exists
      And the local Cookbook "hosts" exists

  Scenario: Clone a single Cookbook from a Cookbooks URI
    Given the remote Cookbooks URI "git://github.com/cookbooks/"
     When I clone the Cookbook "hosts" branch "master" to "ckbk/scratch/myapp/cookbooks/hosts2"
     Then the local Cookbook repository exists
      And the local Cookbook "hosts" exists

  Scenario: Clone a single Site-Cookbook from a Cookbooks URI
    Given the remote Cookbooks URI "git://github.com/cookbooks/"
     When I clone the Cookbook "hosts" branch "master" to "ckbk/scratch/myapp/site-cookbooks/hosts2"
     Then the local Site-Cookbook repository exists
      And the local Site-Cookbook "hosts" exists

  Scenario: Clone multiple Cookbooks from a Cookbooks URI
    Given the remote Cookbooks URI "git://github.com/cookbooks/"
     When I clone the Cookbooks:
     | cookbook | branch | tag       | ref        | destination                         |
     | hosts    |        | 37s.0.1.0 |            | ckbk/scratch/myapp/cookbooks/hosts3 |
     | users    | 37s    |           |            | ckbk/scratch/myapp/cookbooks/users  |
     | xml      | master |           | b7a11ea4eb | ckbk/scratch/myapp/cookbooks/xml    |
      And these local Cookbooks exist:
     | cookbook |
     | hosts3   |
     | users    |
     | xml      |

  Scenario: Clone multiple Site-Cookbooks from a Cookbooks URI
    Given the remote Cookbooks URI "git://github.com/cookbooks/"
     When I clone the Cookbooks:
          |cookbook | branch | destination                         |
          | hosts   | master | ckbk/scratch/myapp/site-cookbooks/hosts4 |
          | users   | master | ckbk/scratch/myapp/site-cookbooks/users2 |
      And these local Site-Cookbooks exist:
          |cookbook |
          | hosts4  |
          | users2  |

  Scenario: Download Site-Cookbooks from a Cookbooks URI
    Given the remote Cookbooks URI "git://github.com/cookbooks/"
     When I clone the Cookbooks:
          | cookbook | branch  | destination                   |
          | users    | 37s     | ckbk/scratch/myapp/cookbooks/users       |
          | users    | 37s     | ckbk/scratch/myapp/site-cookbooks/users2 |
     Then these local Cookbooks exist:
          | cookbook  | site-cookbook  |
          | users     |                |
          |           | users2         |

