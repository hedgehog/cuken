Feature: Checking ports
  In order to test a running system
  As an administrator
  I want to examine executables

  Background
    Given that "cuken/runnable" has been required

  Scenario: An executable exists
    Then the file at "/users/foo/bin/executeme" is executable

  Scenario: An executable is executable by user, group, and other
    Then the file at "/users/foo/bin/executeme" is executable by ugo

  Scenario: An executable is executable by only its owning user
    Then the file at "/users/foo/bin/executeme" is executable by u

  Scenario: An executable is executable by group and other
    Then the file at "/users/foo/bin/executeme" is executable by go

  Scenario: An executable is executable by a specific user
    Then the file at "/users/foo/bin/executeme" is executable by "foo_user"

  Scenario: An executable has the setuid bit set
    Then the file at "/users/foo/bin/executeme" is a setuid executable

  Scenario: An executable has the setgid bit set
    Then the file at "/users/foo/bin/executeme" is a setgid executable

  Scenario: A list of executables should be properly owned and executable
    Then these executables exist:
      | file                 | executors |
      | /Users/foo/bin/group | g         |
      | /Users/foo/bin/user  | u         |
      | /Users/foo/bin/other | o         |
      | /Users/foo/bin/gandu | gu        |
      | /Users/foo/bin/oandg | go        |
      | /Users/foo/bin/oandu | ou        |
      | /Users/foo/bin/all   | ogu       |
    Then these executables exist:
      | file                  | user     |
      | /Users/foo/bin/user   | foo_user |
      | /Users/foo/bin/other  | foo_user |
      | /Users/foo/bin/gandu  | foo_user |
      | /Users/foo/bin/oandg  | foo_user |
      | /Users/foo/bin/oandu  | foo_user |
      | /Users/foo/bin/all    | foo_user |
      | /Users/foo/bin/nobody | nobody   |
      | /Users/foo/bin/root   | root     |
    Then these executables exist:
      | file                  | user     | setuid | setgid |
      | /Users/foo/bin/setuid | foo_user | true   | false  |
      | /Users/foo/bin/setgid | foo_user | false  | true   |
      | /Users/foo/bin/user   | foo_user | false  | false  |

  Scenario: A command should print a specific string
    Then the command "python --version" yields "Python 2.7.1"

  Scenario: A command's response should contain a specific string
    Then the command "java -version" yields a response containing "java version "1.6.0_33""

  Scenario: A list of commands respond properly
    Then these executables respond properly:
      | command      | response |
      | echo hello   | hello    |
      | uname        | Darwin   |
      | whoami       | foo_user |
    Then these executables respond properly:
      | command          | response contains       |
      | java -version    | java version "1.6.0_33" |
      | python --version | Python 2.7.1            |
