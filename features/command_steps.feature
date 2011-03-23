@step_features
Feature: Listing file steps
  In order to test a running system
  As an administrator
  I want to know what command steps are available

  Background:
    Given that "cuken/cmd" has been required

  Scenario: Command execution
    Then these steps are defined for "cuken/cucumber/cmd.rb":
      | step                                                   |
      |I run `([^`]*)`                                         |
      |I run `([^`]*)` interactively                           |
      |I successfully run `([^`]*)`                            |
      |I type "([^"]*)"                                        |

  Scenario: Command exit status
    Then these steps are defined for "cuken/cucumber/cmd.rb":
      | step                                                   |
      |the exit status should be (\d+)                         |
      |the exit status should not be (\d+)                     |
#    Pending:
#    https://rspec.lighthouseapp.com/projects/16211-cucumber/tickets/707-element-size-differs-2-should-be-1-indexerror
#      |it should (pass|fail) with:                             |
#      |it should (pass|fail) with exactly:                     |
#      |it should (pass|fail) with regexp?:                     |

  Scenario: Command output (stdout+stderr)
    Then these steps are defined for "cuken/cucumber/cmd.rb":
      | step                                                   |
      |the output from "(.*)" contains exactly:                |
      |the output from "([^"]*)" does not contain exactly:     |
      |the output from "([^"]*)" contains:                     |
      |the output from "([^"]*)" does not contain:             |
      |the output from "([^"]*)" should contain "([^"]*)"      |
      |the output from "([^"]*)" should not contain "([^"]*)"  |
      |the output should contain "([^"]*)"                     |
      |the output should contain:                              |
      |the output should contain exactly "([^"]*)"             |
      |the output should contain exactly:                      |
      |the output should match \/([^\/]*)\/                    |
      |the output should match:                                |
      |the output should not contain "([^"]*)"                 |
      |the output should not contain:                          |

  Scenario: Command stderr
    Then these steps are defined for "cuken/cucumber/cmd.rb":
      | step                                                   |
      |the stderr from "([^"]*)" should contain "([^"]*)"      |
      |the stderr from "([^"]*)" should not contain "([^"]*)"  |
      |the stderr should contain "([^"]*)"                     |
      |the stderr should contain:                              |
      |the stderr should contain exactly:                      |
      |the stderr should not contain "([^"]*)"                 |
      |the stderr should not contain:                          |

  Scenario: Command stdout
    Then these steps are defined for "cuken/cucumber/cmd.rb":
      | step                                                   |
      |the stdout from "([^"]*)" should contain "([^"]*)"      |
      |the stdout from "([^"]*)" should not contain "([^"]*)"  |
      |the stdout should contain "([^"]*)"                     |
      |the stdout should contain:                              |
      |the stdout should contain exactly:                      |
      |the stdout should not contain "([^"]*)"                 |
      |the stdout should not contain:                          |

