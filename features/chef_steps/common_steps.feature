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
      |the Chef admin client "([^"]*)" exists                           |
      |the Chef client "([^"]*)" exists                                 |
      |the Chef client private key path "([^"]*)"                       |
      |the Chef root directory "([^"]*)" exists                         |
      |the Chef server URI "([^"]*)"                                    |

  Scenario: Chef actions
    Then these steps are defined for "cuken/cucumber/chef/common.rb":
      | step                                                            |
      |I create the Chef admin client "([^"]*)"                         |
      |I create the Chef client "([^"]*)"                               |
      |I delete the Chef admin client "([^"]*)"                         |
      |I delete the Chef client "([^"]*)"                               |

  Scenario: Local and remote Chef repository commands
    Then these steps are defined for "cuken/cucumber/chef/common.rb":
      | step                                                            |
      |a default base Chef repository in "([^"]*)"                      |
      |I clone the remote Chef repository branch "([^"]*)" to "([^"]*)" |
      |the local Chef repository "([^"]*)"                              |
      |the local Chef repository exists                                 |
      |the remote Chef repository "([^"]*)"                             |
