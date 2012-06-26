@step_features
Feature: Process steps
  In order to test a running system
  As an administrator
  I want to examine executables

  Background:
    Given that "cuken/runnable" has been required

  Scenario: Executable existence, ownership, and attributes
    Then these steps are defined for "cuken/cucumber/runnable.rb":
      | step                                                      |
      | the file at "([^"]*)" is executable                       |
      | the file at "([^"]*)" is a setuid executable              |
      | the file at "([^"]*)" is a setgid executable              |
      | the file at "([^"]*)" is executable by ([ugo]{1,3})       |
      | the file at "([^"]*)" is executable by "([^"]*)"          |
      | these executables exist:                                  |
      | the command "([^"]*)" yields "(.*)"                       |
      | the command "([^"]*)" yields a response containing "(.*)" |
      | these executables respond properly:                       |
