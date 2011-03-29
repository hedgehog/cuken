@chef @cookbook @step_features
Feature: Listing Chef Cookbook steps
  In order to test automated Chef deployments
  As an administrator
  I want to know what Cookbook steps are available

  Background:
    Given that "cuken/chef" has been required

  Scenario: Common Node
    Then these steps are defined for "cuken/cucumber/chef/node.rb":
      | step                                                                |
      |a validated node  |
      |the nodes are:    |
