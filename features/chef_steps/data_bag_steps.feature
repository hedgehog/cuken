@chef @data_bag @step_features
Feature: Listing Node steps
  In order to test automated Chef deployments
  As an administrator
  I want to know what Data Bag steps are available

  Background:
    Given that "cuken/chef" has been required

  Scenario: Common Data Bag steps
    Then these steps are defined for "cuken/cucumber/chef/data_bag.rb":
      | step                                |
      |I add these Cookbook Data Bag items: |
      |I create the Data Bag "([^"]*)"      |
      |these Data Bags exist:               |
      |these Data Bags do not exist:        |
      |these Data Bags contain:             |
      |these Data Bags do not contain:      |
