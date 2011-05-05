@chef @vagrant @step_features @announce
Feature: Vagrant steps
  In order to test automated Chef deployments
  As an administrator
  I want to know what Vagrant steps are available

  Background:
    Given that "cuken/chef" has been required

  Scenario: Vagrant
    Then these steps are defined for "cuken/cucumber/vagrant.rb":
      | step                                                   |
      |the Vagrantfile "([^\"]*)" exists |