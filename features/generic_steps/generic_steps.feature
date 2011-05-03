@step_features
Feature: Generic steps
  In order to test a running system
  As an administrator
  I want to know what common steps are available

  Background:
      Given that "cuken/common" has been required

  Scenario: Common execution
       Then these steps are defined for "cuken/cucumber/common.rb":
            | step                              |
            |wait "([^"]*)" seconds             |
            |I'm using a clean gemset "([^"]*)" |
