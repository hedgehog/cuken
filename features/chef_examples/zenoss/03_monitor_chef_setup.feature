@announce
Feature: Zenoss Monitoring
  In order to launch a Zenoss server
  As a admin/developer
  I want to define the Chef configuration via executable features

  Background:
    Given the Chef root directory "/tmp/chef" exists
      And the state of VM "chef" is "running"
      And I switch Vagrant environment
      And the Chef root directory "/tmp/monitor" exists
      And the state of VM "monitor" is not "running"

  Scenario: Download Cookbooks from one Cookbooks URI
    Given the remote Cookbooks URI "git://github.com/cookbooks/"
     When I clone the Cookbooks:
          | cookbook | branch | tag    | ref        | destination                |
          | apt      | master |        |            | monitor/cookbooks/apt      |
          | openssh  | master |        | 9a8ce8ce44 | monitor/cookbooks/openssh  |
          | openssl  | master |        |            | monitor/cookbooks/openssl  |
          | yum      | master |        |            | monitor/cookbooks/yum      |
      And these local Cookbooks exist:
          | cookbook  |
          | apt       |
          | openssh   |
          | openssl   |
          | yum       |
     Then I place all in "monitor" in "/tmp/monitor"

  Scenario: Download Site-Cookbooks from another Cookbooks URI
    Given the remote Cookbooks URI "git@github.com:hedgehog/"
     When I clone the Cookbooks:
          | cookbook | branch    | destination                   |
          | zenoss   | qa        | monitor/site-cookbooks/zenoss |
      And these local Cookbooks exist:
          | site-cookbook  |
          | zenoss         |
     Then I place all in "monitor" in "/tmp/monitor"

  Scenario: Load Roles from Cookbooks
     Given the Chef root directory "/tmp/monitor" exists
       And a Cookbooks path "/tmp/monitor/cookbooks/"
       And a Cookbooks path "/tmp/monitor/site-cookbooks/"
       And the Knife file "/tmp/monitor/.chef/knife.rb"
      When I load the Roles:
           | site-cookbook | role                            |
           | zenoss        | Class_Server-SSH-Linux.rb       |
           | zenoss        | Class_Server-SSH-Linux-MySQL.rb |
           | zenoss        | Location_Austin.rb              |
           | zenoss        | Location_Seattle.rb             |
           | zenoss        | ZenossServer.rb                 |
      Then these Roles exist:
           | role                |
           | ServerSSHLinux      |
           | ServerSSHLinuxMySQL |
           | Austin              |
           | Seattle             |
           | ZenossServer        |

  Scenario: Load Data Bag from Cookbooks
    Given the Chef root directory "/tmp/monitor" exists
      And a Cookbooks path "/tmp/monitor/cookbooks/"
      And a Cookbooks path "/tmp/monitor/site-cookbooks/"
      And I create the Data Bag "users"
     When I add these Cookbook Data Bag items:
          | site-cookbook | data_bag | item                       |
          | zenoss        | users    | Zenoss_User.json           |
          | zenoss        | users    | Zenoss_Readonly_User.json  |
     Then these Data Bags exist:
          | data_bag |
          | users    |
      And these Data Bags contain:
          | data_bag | item        |
          | users    | readonly    |
          | users    | zenossadmin |

  Scenario: Build Node Run Lists
    Given the Chef root directory "/tmp/monitor" exists
      And the Node "monitor" exists
     When I add these Roles to the Nodes:
          | node     | role                       |
          | monitor  | ZenossServer               |

  Scenario: Upload the Cookbooks
    Given the Chef root directory "/tmp/monitor" exists
     When I load the Cookbooks:
          | cookbook  | site-cookbook  |
          | apt       |                |
          | openssh   |                |
          | openssl   |                |
          |           | zenoss         |
          | yum       |                |
     Then these remote Cookbooks exist:
          | cookbook  | site-cookbook  |
          | apt       |                |
          | openssh   |                |
          | openssl   |                |
          |           | zenoss         |
          | yum       |                |

  @cosmic
  Scenario: Launch the Vagrant VM Monitor
    Given the state of VM "monitor" is not "running"
      And the Chef root directory "/tmp/monitor" exists
      And the Vagrantfile "/tmp/monitor/Vagrantfile" exists
     When I launch the VM "monitor"
     Then the state of VM "monitor" is "running"


