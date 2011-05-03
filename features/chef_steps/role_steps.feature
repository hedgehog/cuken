@chef @role @step_features
Feature: Role steps
  In order to test automated Chef deployments
  As an administrator
  I want to know what Role steps are available

  Background:
    Given that "cuken/chef" has been required

  Scenario: Common Role steps
    Then these steps are defined for "cuken/cucumber/chef/role.rb":
      | step                       |
      |I load the Roles:           |
      |these Roles exist:          |
      |these Roles do not exist:   |
      |the Roles are:              |

