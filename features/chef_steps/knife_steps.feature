@chef @knife @step_features
Feature: Knife steps
  In order to test automated Chef deployments
  As an administrator
  I want to know what Knife steps are available

  Background:
    Given that "cuken/chef" has been required

  Scenario: Knife file
    Then these steps are defined for "cuken/cucumber/chef/knife.rb":
      | step                                                   |
      |the Knife file "([^"]*)"                                |

  Scenario: Knife commands
    Then these steps are defined for "cuken/cucumber/chef/knife.rb":
      | step                                                   |
      |I successfully run Knife's "([^"]*)"                    |
      |I interactively run Knife's "([^"]*)"                   |
