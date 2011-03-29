@chef @common @step_features
Feature: Listing common steps
  In order to test automated Chef deployments.
  As an administrator.
  I want to know what generic steps are available.

  Background:
    Given that "cuken/chef" has been required

  Scenario: Common Chef
    Then these steps are defined for "cuken/cucumber/chef/common.rb":
      | step                                                            |
      |a default base Chef repository in "([^"]*)"                      |
      |I clone the remote Chef repository branch "([^"]*)" to "([^"]*)" |
      |the Chef server URI "([^"]*)"                                    |
      |the Chef client "([^"]*)"                                        |
      |the Chef admin client "([^"]*)"                                  |
      |the Chef client private key path "([^"]*)"                       |

  Scenario: Local and remote Chef repository commands
    Then these steps are defined for "cuken/cucumber/chef/common.rb":
      | step                                                            |
      |the local Chef repository "([^"]*)"                              |
      |the local Chef repository exists                                 |
      |the remote Chef repository "([^"]*)"                             |
