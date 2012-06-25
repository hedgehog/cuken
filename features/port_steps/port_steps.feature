@step_features
Feature: Port steps
  In order to test a running system
  As an administrator
  I want to know what port steps are available

  Background:
    Given that "cuken/port" has been required

  Scenario: File and directory existence
    Then these steps are defined for "cuken/cucumber/port.rb":
      | step                                                   |
      |the port "([^"]*)" is open                              |
      |the port "([^"]*)" is not open                          |
      |the port "([^"]*)" is open on host "([^"]*)"            |
      |the port "([^"]*)" is not open on host "([^"]*)"        |
      |these ports are open:                                   |
      |these ports are not open:                               |

