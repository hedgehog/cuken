@step_features
Feature: Listing file steps
  In order to test a running system
  As an administrator
  I want to know what files steps are available

  Background:
    Given that "cuken/file" has been required

  Scenario: File and directory navigation
    Then these steps are defined for "cuken/cucumber/file.rb":
      | step                                                   |
      |I cd to "([^"]*)"                                       |

  Scenario: File and directory existence
    Then these steps are defined for "cuken/cucumber/file.rb":
      | step                                                   |
      |a directory named "([^"]*)"                             |
      |I remove the file "([^"]*)"                             |
      |the directory "([^"]*)" exists                          |
      |the directory "([^"]*)" does not exist                  |
      |the file "([^"]*)" exists                               |
      |the file "([^"]*)" does not exist                       |
      |the file "([^"]*)" should not exist                     |
      |these files exist:                                      |
      |these files do not exist:                               |
      |these directories exist:                                |
      |these directories do not exist:                         |

  Scenario: File and directory properties
    Then these steps are defined for "cuken/cucumber/file.rb":
      | step                                                   |
      |the directory "([^"]*)" has decimal mode "(\d+)"        |
      |the directory "([^"]*)" has octal mode "(\d+)"          |
      |the directory "([^"]*)" is owned by "([^"]*)"           |
      |the file "([^"]*)" has decimal mode "(\d+)"             |
      |the file "([^"]*)" has octal mode "(\d+)"               |
      |the file "([^"]*)" is owned by "([^"]*)"                |
      |the (.)time of "([^"]*)" changes                        |
      |we record the a-mtime of "([^"]*)"                      |

  Scenario: File and directory content
    Then these steps are defined for "cuken/cucumber/file.rb":
      | step                                                               |
      |the file "([^"]*)" with:                                            |
      |the empty file "([^"]*)"                                            |
      |the file "([^"]*)" contains "([^"]*)"                               |
      |the file "([^"]*)" contains \/([^\/]*)\/                             |
      |the file "([^"]*)" contains exactly:                                |
      |the file "([^"]*)" contains "([^"]*)" exactly "(\d+)" times         |
      |the file "([^"]*)" does not contain "([^"]*)"                       |
      |the file "([^"]*)" does not contain \/([^\/]*)\/                      |
      |the file "([^"]*)" does not contain exactly:                        |
      |the file "([^"]*)" does not contain "([^"]*)" exactly "(\d+)" times |
      |I write to "([^"]*)" with:                                          |
      |I overwrite "([^"]*)" with:                                         |
      |I append to "([^"]*)" with:                                         |

