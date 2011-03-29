# For complete Aruba step listing see:
# lib/aruba/cucumber.rb
# or https://github.com/aslakhellesoy/aruba/blob/master/lib/aruba/cucumber.rb
Feature: Examining files
  In order to test a running system
  As an administrator
  I want to examine files

  Background
    Given that "cuken/file" has been required

  @steps
  Scenario: File exists
    Given the empty file "foo.file"
     Then the file "foo.file" exists

  @steps
  Scenario: File does not exist
     Then the file "foo.filepants" does not exist

  @steps
  Scenario: Atime
    Given the empty file "foo.file"
      And we record the a-mtime of "foo.file"
      And I run `sleep 1`
      And I run `touch -a foo.file`
     Then the atime of "foo.file" changes

  @steps
  Scenario: Mtime
    Given an empty file named "foo.file"
      And we record the a-mtime of "foo.file"
      And I run `sleep 1`
      And I run `touch -m foo.file`
     Then the mtime of "foo.file" changes

  @steps
  Scenario: File contents
    When I write to "monkeytest.file" with:
    """
    monkeypants
    monkeyshorts
    """
    Then the file "monkeytest.file" contains "monkeypants"

  @steps
  Scenario: File contents exact match
    When I write to "monkeytest.file" with:
    """
    monkeypants
    monkeyshorts

    """
    Then the file "monkeytest.file" contains exactly:
    """
    monkeypants
    monkeyshorts

    """
  Scenario: File contents multiple matches
    When I write to "monkeytest.file" with:
    """
    monkeypants
    monkeyshorts
    monkeypants
    monkeyshorts

    """
    Then the file "monkeytest.file" contains "monkeyp" exactly "2" times
    Then the file "monkeytest.file" does not contain "monkey" exactly "2" times

  @steps
  Scenario: File modes
    When I run `touch filemode.file`
     And I run `chmod 644 filemode.file`
    Then the file "filemode.file" has octal mode "188"
    And the file "filemode.file" has octal mode "33188"
    And the file "filemode.file" has decimal mode "644"
    And the file "filemode.file" has decimal mode "0644"

  @steps
  Scenario: Directory exists
    When I run "mkdir -p dirtest"
    Then the directory "dirtest" exists

  @steps
  Scenario: Directory does not exist
    Then the directory "dirtest-m000" does not exist

  @steps
  Scenario: Directory modes
    When I run `mkdir -p dirtest`
     And I run `chmod 755 dirtest`
     Then the directory "dirtest" has decimal mode "755"
     And the directory "dirtest" has decimal mode "2755"
    Then the directory "dirtest" has octal mode "901"
    And the directory "dirtest" has octal mode "17901"
