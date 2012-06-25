Feature: Checking ports
  In order to test a running system
  As an administrator
  I want to examine ports

  Background
    Given that "cuken/port" has been required

  Scenario: SSH Port is open
    Then the port "22" is open

  Scenario: Random port is not open
    Then the port "5033" is not open

  Scenario: HTTP Port is open on your router
    Then the port "80" is open on host "192.168.42.1"

  Scenario: Random port is not open on your router
    Then the port "5033" is not open on host "192.168.42.1"

  Scenario: List of ports are open
    Then these ports are open:
      | port |
      | 22   |
      | 548  |

  Scenario: List of ports are not open
    Then these ports are not open:
      | port |
      | 5033 |
      | 5034 |
      | 5035 |

  Scenario: List of ports are open on your router
    Then these ports are open:
      | port | host         |
      | 53   | 192.168.42.1 |
      | 80   | 192.168.42.1 |

  Scenario: List of ports are not open
    Then these ports are not open:
      | port | host         |
      | 5033 | 192.168.42.1 |
      | 5034 | 192.168.42.1 |
      | 5035 | 192.168.42.1 |
