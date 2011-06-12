@announce @git_quick
Feature: Git cloning
  In order to manage application and configuration code using Git
  As an Administrator
  I want to clone Git Repositories

  Background:
    Given a default Git repository in "ckbk/scratch/myapp"

  Scenario: Clone from a Git repository
    Given Explanation: Next we step up two levels to escape Aruba's working folder
      And the remote Git repository "./../../features/data/repositories/cookbooks/hosts/.git"
     When I clone the remote Git repository branch "master" to "ckbk/scratch/myapp/cookbooks/hosts"
     Then the local Git repository exists

