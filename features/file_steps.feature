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
      |a directory named "([^"]*)" should exist                |
      |a directory named "([^"]*)" should not exist            |
      |a file named "([^"]*)" should exist                     |
      |a file named "([^"]*)" should not exist                 |
      |I remove the file "([^"]*)"                             |
      |the directory "([^"]*)" exists                          |
      |the directory "([^"]*)" does not exist                  |
      |the file "([^"]*)" exists                               |
      |the file "([^"]*)" does not exist                       |
      |the file "([^"]*)" should not exist                     |
      |the following directories should exist:                 |
      |the following directories should not exist:             |
      |the following files should exist:                       |
      |the following files should not exist:                   |
      |these files exist:                                      |
      |these files do not exist:                               |
      |these directories exist:                                |
      |these directories do not exist:                         |

  Scenario: File and directory properties
    Then these steps are defined for "cuken/cucumber/file.rb":
      | step                                                   |
      |the file "([^"]*)" has mode "([^"]*)"                   |
      |the directory "([^"]*)" has decimal mode "(\d+)"        |
      |the directory "([^"]*)" has octal mode "(\d+)"          |
      |the directory "(.+)" is owned by "(.+)"                 |
      |the file "([^"]*)" has decimal mode "(\d+)"             |
      |the file "([^"]*)" has octal mode "(\d+)"               |
      |the file "(.+)" is owned by "(.+)"                      |
      |the (.)time of "(.+)" changes                           |
      |we record the a-mtime of "(.+)"                         |

  Scenario: File and directory content
    Then these steps are defined for "cuken/cucumber/file.rb":
      | step                                                               |
      |a file named "([^"]*)" with:                                        |
      |an empty file named "([^"]*)"                                       |
      |the file "([^"]*)" with:                                            |
      |the empty file "([^"]*)"                                            |
      |the file "([^"]*)" contains "([^"]*)"                               |
      |the file "([^"]*)" contains "([^"]*)" exactly (\d+) times           |
      |the file "([^"]*)" contains exactly:                                |
      |the file "([^"]*)" does not contain "([^"]*)" exactly "(\d+)" times |
      |the file "([^"]*)" should contain "([^"]*)"                         |
      |the file "([^"]*)" should not contain "([^"]*)"                     |
      |the file "([^"]*)" should contain exactly:                          |
      |the file "([^"]*)" should match \/([^\/]*)\/                        |
      |the file "([^"]*)" should not match \/([^\/]*)\/                    |
      |I write to "([^"]*)" with:                                          |
      |I overwrite "([^"]*)" with:                                         |
      |I append to "([^"]*)" with:                                         |

