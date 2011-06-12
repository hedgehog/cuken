@announce @git_quick
Feature: Git cloning
  In order to manage application and configuration code using Git
  As an Administrator
  I want to clone Git Repositories

  Background:
    Given a default Git repository in "ckbk/scratch/myapp"

  Scenario: Clone from a Git repository
    Given Explanation: Next we step up two levels to escape Aruba's working folder
      And the Git repository "./../../features/data/repositories/cookbooks/hosts/.git"
     When I clone the remote Git repository branch "master" to "ckbk/scratch/myapp/cookbooks/hosts"
     Then the local Git repository exists

  Scenario: Clone a single Repository from a Git URI
    Given the Git URI "git://github.com/cookbooks/"
     When I clone the Repository "hosts" branch "master" to "ckbk/scratch/myapp/cookbooks/hosts2"
     Then the local Git repository exists

  Scenario: Clone multiple Repositories from a Git URI
    Given the Git URI "git://github.com/cookbooks/"
     When I clone the Repositories:
     | repo     | branch | tag       | ref        | destination                         |
     | hosts    |        | 37s.0.1.0 |            | ckbk/scratch/myapp/cookbooks/hosts3 |
     | users    | 37s    |           |            | ckbk/scratch/myapp/cookbooks/users  |
     | xml      | master |           | b7a11ea4eb | ckbk/scratch/myapp/cookbooks/xml    |
      And these local Repositories exist:
     | repo                                  |
     | ckbk/scratch/myapp/cookbooks/hosts3   |
     | ckbk/scratch/myapp/cookbooks/users    |
     | ckbk/scratch/myapp/cookbooks/xml      |

