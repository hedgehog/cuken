@chef @cookbook @step_features
Feature: Listing Cookbook steps
  In order to test automated Chef deployments
  As an administrator
  I want to know what Cookbook steps are available

  Background:
    Given that "cuken/chef" has been required

  Scenario: Common Chef
    Then these steps are defined for "cuken/cucumber/chef/cookbook.rb":
      | step                                                                |
      |a cookbook path "([^"]*)"                                            |
      |a cookbooks path "([^"]*)"                                           |
      |I successfully generate all cookbook metadata                        |
      |I successfully generate cookbook "([^"]*)" metadata                  |
      |the local cookbook "([^"]*)" exists                                  |

  Scenario: Local and remote Cookbook repository commands
    Then these steps are defined for "cuken/cucumber/chef/cookbook.rb":
      | step                                                                |
      |I clone the Cookbooks:                                               |
      |I clone the Cookbook "([^"]*)" branch "([^"]*)" to "([^"]*)"         |
      |I clone the remote Cookbook repository branch "([^"]*)" to "([^"]*)" |
      |the local Cookbook repository "([^"]*)"                              |
      |the local Cookbook repository exists                                 |
      |the remote Cookbook repository "([^"]*)"                             |
      |the remote Cookbooks URI "([^"]*)"                                   |
      |these local Cookbooks exist:                                         |
      |these local Site-Cookbooks exist:                                         |

