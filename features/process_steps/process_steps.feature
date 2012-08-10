@step_features
Feature: Process steps
  In order to test a running system
  As an administrator
  I want to know what process steps are available

  Background:
    Given that "cuken/process" has been required

  Scenario: Process existence, stability, and ownership
    Then these steps are defined for "cuken/cucumber/process.rb":
      | step                                                        |
      | a process named "([^"\*)" is running                        |
      | a process named "([^"\*)" is not running                    |
      | a process named "([^"\*)" is running and owned by "([^"]*)" |
      | a process named "([^"\*)" is running with pid "([^"]*)"     |
      | these processes are running:                                |
