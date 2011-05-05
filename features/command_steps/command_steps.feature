@step_features
Feature: Command steps
  In order to test a running system
  As an administrator
  I want to know what command steps are available

  Background:
    Given that "cuken/cmd" has been required

  Scenario: Command execution
    Then these steps are defined for "cuken/cucumber/cmd/execution.rb":
         | step                                                   |
         |I run `([^`]*)`                                         |
         |I run `([^`]*)` in "([^"]*)"                            |
         |I interactively run `([^`]*)`                           |
         |I interactively run `([^`]*)` in "([^"]*)"              |
         |I successfully run `([^`]*)`                            |
         |I successfully run `([^`]*)` in "([^"]*)"               |
         |I type "([^"]*)"                                        |

  Scenario: Command exit status
    Then these steps are defined for "cuken/cucumber/cmd/exit_status.rb":
         | step                                                   |
         |the exit status should be (\d+)                         |
         |the exit status should not be (\d+)                     |
#    Pending:
#    https://rspec.lighthouseapp.com/projects/16211-cucumber/tickets/707-element-size-differs-2-should-be-1-indexerror
#      |it should (pass|fail) with:                             |
#      |it should (pass|fail) with exactly:                     |
#      |it should (pass|fail) with regexp?:                     |

  Scenario: All output (stdout+stderr) per command
    Then these steps are defined for "cuken/cucumber/output/cmd.rb":
         | step                                                |
         |the output from "([^"]*)" contains exactly:          |
         |the output from "([^"]*)" does not contain exactly:  |
         |the output from "([^"]*)" contains:                  |
         |the output from "([^"]*)" does not contain:          |
         |the output from "([^"]*)" contains "([^"]*)"         |
         |the output from "([^"]*)" does not contain "([^"]*)" |

  Scenario: All output (stdout+stderr) for all commands
    Then these steps are defined for "cuken/cucumber/output/all.rb":
      | step                                                   |
      |the output contains "([^"]*)"                     |
      |the output contains:                              |
      |the output contains exactly "([^"]*)"             |
      |the output contains exactly:                      |
      |the output does not contain "([^"]*)"                 |
      |the output does not contain:                          |
      |the output matches \/([^\/]*)\/                    |
      |the output matches:                                |

  Scenario: Command stderr
    Then these steps are defined for "cuken/cucumber/output/stderr.rb":
      | step                                                   |
      |the stderr from "([^"]*)" contains "([^"]*)"      |
      |the stderr from "([^"]*)" does not contain "([^"]*)"  |
      |the stderr contains "([^"]*)"                     |
      |the stderr contains:                              |
      |the stderr contains exactly:                      |
      |the stderr does not contain "([^"]*)"                 |
      |the stderr does not contain:                          |

  Scenario: Command stdout
    Then these steps are defined for "cuken/cucumber/output/stdout.rb":
      | step                                                   |
      |the stdout from "([^"]*)" contains "([^"]*)"      |
      |the stdout from "([^"]*)" does not contain "([^"]*)"  |
      |the stdout contains "([^"]*)"                     |
      |the stdout contains:                              |
      |the stdout contains exactly:                      |
      |the stdout does not contain "([^"]*)"                 |
      |the stdout does not contain:                          |

