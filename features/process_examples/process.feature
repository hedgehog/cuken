Feature: Checking ports
  In order to test a running system
  As an administrator
  I want to check processes

  Background
    Given that "cuken/process" has been required

  Scenario: Kernel extension server is running
    Then a process named "kextd" is running

  Scenario: Magical unicorn server is not running
    Then a process named "magicalunicornd" is not running

  Scenario: Kernel extension server is running and owned by root
    Then a process named "kextd" is running and owned by "root"

  Scenario: List of processes are running
    Then these processes are running:
      | name    |
      | kextd   |
      | notifyd |
      | syslogd |

  Scenario: List of processes are running and properly owned
    Then these processes are running:
      | name    | owner |
      | kextd   | root  |
      | notifyd | root  |
      | syslogd | root  |

  Scenario: List of processes are running and properly owned with specific pids:
    Then these processes are running and stable:
      | name    | owner | pid |
      | kextd   | root  | 10  |
      | notifyd | root  | 14  |
      | syslogd | root  | 20  |
