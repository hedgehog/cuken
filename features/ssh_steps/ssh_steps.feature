@step_features
Feature: Listing SSH steps
  In order to test a running system
  As an administrator
  I want to know what SSH steps are available

  Background:
    Given that "cuken/ssh" has been required

  Scenario: SSH
    Then these steps are defined for "cuken/cucumber/ssh.rb":
      | step                                       |
      |a SSH client user                           |
      |a SSH client user "([^\"]*)"                |
      |a SSH client hostname                       |
      |a SSH client hostname "([^\"]*)"            |
      |default ssh-forever options                 |
      |I initialize password-less SSH access       |
      |I initialize password-less SSH access for:  |
      |the ssh-forever options:                    |
