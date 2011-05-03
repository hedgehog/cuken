@chef @node @step_features
Feature: Node steps
  In order to test automated Chef deployments
  As an administrator
  I want to know what Node steps are available

  Background:
    Given that "cuken/chef" has been required

  Scenario: Common Node steps
    Then these steps are defined for "cuken/cucumber/chef/node.rb":
      | step                           |
      |a validated Node                |
      |I add these Roles to the Nodes: |
      |the Node "([^"]*)" exists       |
      |the Nodes are:                  |
