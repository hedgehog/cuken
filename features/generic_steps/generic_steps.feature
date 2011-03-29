@step_features
Feature: Listing common steps
  In order to test a running system
  As an administrator
  I want to know what common steps are available

  Background:
    Given that "cuken/common" has been required

  Scenario: Common execution
    Then these steps are defined for "cuken/cucumber/common.rb":
      | step                                                   |
      |wait "([^"]*)" seconds                                  |
