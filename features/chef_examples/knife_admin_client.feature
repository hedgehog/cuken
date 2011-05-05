#
# NOTE: This is an example of Cuken usage. Assuming:
# - A Chef server on localhost:4000 (point to yours)
# - An admin client named bobo exists on that Chef server
#
# If you wish to mock a Chef server, see the Chef project's
# features setup.
#
@announce @knife @cookbook_upload
Feature: Reusable Chef Knife steps
  In order to write Chef features describing post-convergence system integration
  As a Chef user
  I want to describe features without having to implement Knife steps

  Background:
    Given the Chef server URI "http://localhost:4000"
      And the Chef admin client "bobo-admin" exists
      And the directory "foo/bar"
      And the file "foo/bar/bobo-admin.pem" contains:
    """
    -----BEGIN RSA PRIVATE KEY-----
    MIIEogIBAAKCAQEA2iu6ETTD3Ig/0dlbbQSPsVcSUGQ3O3Kgt+6h6OwD1HnQUHge
    NEdVwiGXuICSlRAJMHCmgy5+f/Wl3ic2yCfFrQwNG4zkD/lfM9fSsIfPsQcUoe5i
    9xJTbtpT26Y5bkBqynHYOxtZTVZmxzA/XKZ+PvrBc0lU9FMx6P6F3bDo1SB3ZU3M
    zzJ/a1Owyu20qXSwjKYmr2MlU/0Abf/gOyghl1evljkZ5VOS721DVw0vjbgSx+Sp
    cyOFmKEnwMp6QBZTdak271D6/zJHFIUaCc4MLTXlchdZFOUUxF+GdlbxS+iEjX8q
    MnIxP9ZFIcTw26i+MTeNEjTQ9G3nAv/l0AymDQIDAQABAoIBAHY0gteXsxbla06T
    aYmjkwcOmgmcgqBe9t0xGeBNH7YbWdZ/fj3s+HX6JW39m23QBmqMXmts4XUK7xdy
    P6gqhFvBz8hBib9t6Tr5kFm8+7Z6k584vb4H29SPzieP5EXr+PA+xl0f8D6KtZzu
    cyYLvxL4YZ/I95J5EO2gGX+Hvl7Z+/VguyyagApZqZPCh3tQMKNRInFlqUV9VFXa
    g8+EFwPfTqfHg/gWIBU36weAsZHOTP/Oeh00fbaSXeQD/BJImqnJB3Vlb++bQIRF
    OI1SuttkNHTPRx8Ma4/3I/4GK6GhIyFh247T0MrmW+Zi7gQQ8UvYdzf/nlPvdWHP
    ak50GzECgYEA99E+5QdUkVDX29gFPOSxJ4IlAFydEjL9+WcmTCESkLgRi+QfDX8l
    vhssdwm6pHiH4x9xkUbjQ7WSFrVGK19zyZBuK9OcS9wGHf2AE8D7yB4nQcDVY4yT
    sLRmBRWtCxksj5jrQm1jAwF1/eWwYF5lyGZzX7UfxISZ24o6IVUiSFcCgYEA4V/i
    X+mf84w9VtPZIZXurZylRZDri64kavy0/8yf4uOrZvuRGIsFBghOhf9uc4hQD7fw
    jqTdLQO7fTOH/7MB5qbiRPDfwmTfZC8AM9wiSqXGOhQIHAPk/ydJGaMI0ugYLVhw
    SG6E7meBiaxi27UhH2aCv81yGAh8oCd/6211ljsCgYAMHJLpWKFedMgH+5fN8RNj
    be3nBZ+7mvhkrxDlGZyxq/1Xi++kljk/AE79BmGz1hw2EnxXcFJ9JaudJoDmb8TV
    7hQkWjRCVN+Lqa8PyBfGIQskIIuNUPqK4VY3G2cYqsNNxViCJ5x2MiUVIpurKhHp
    aHBtFgoWbbCjVS8gH+wMAwKBgFs5M2j9KHgtOJrPjyDQDlcJg8Afw6e7KhSAC0dK
    7SCqZLN/eiCEDNl/PUFxvaRX9YgXPPCP/NJ+o0IvPIocS9WvkQC0uu11ZRKpD5zu
    KpcqeI0DlLC6RtOcdDNDUYwE09xu4qv+yCGzlbRDKZSiwTBzjtLR9q+Rp9gvhNCn
    cqQHAoGAaW+Ve4BxC+/eyZ5yOPqp4IJDZuXQR/45zyUc+JNFSxIzg6W650JlK/Q6
    Rr9nYisbBdjVA38WzK+aOm1bs+yCzepDNa+QDrtIvuuKUHP2XWLGa2kpAD95K5du
    osFXY7fq6Hd9CEFLcDacyxXShu095MPJGTSBwwykWo+C+DUC5ts=
    -----END RSA PRIVATE KEY-----
    """
    And the file "foo/bar/.chef/knife.rb" contains:
    """
    current_dir = File.dirname(__FILE__)
    log_level :debug
    log_location $stdout
    node_name "bobo-admin"
    client_key "#{File.dirname(current_dir)}/bobo-admin.pem"
    chef_server_url "http://localhost:4000"
    cache_type 'Memory'
    cache_options( :path => "#{ENV['HOME']}/.chef/checksums" )
    cookbook_path ["#{current_dir}/../cookbooks","#{current_dir}/../site-cookbooks"]

    """

  Scenario: Knife steps default knife.rb path
     Given I cd to "foo/bar"
      When I successfully run `knife node list`
      Then the output contains:
     """
     DEBUG: Signing the request as bobo-admin
     DEBUG: Sending HTTP Request via GET to localhost:4000/nodes
     [
     """

  Scenario: Knife steps with path to knife.rb created earlier
     Given the Knife file "foo/bar/.chef/knife.rb"
       And Explanation: to check a list of Chef nodes
      When the Nodes are:
      | node |
      |      |
      Then the output contains:
     """
     DEBUG: Signing the request as bobo-admin
     DEBUG: Sending HTTP Request via GET to localhost:4000/nodes
     [
     """

  Scenario: Upload a non-Git managed cookbook with path to knife.rb created earlier
    Given the Knife file "foo/bar/.chef/knife.rb"
      And I cd to "./../../"
      And a Cookbook path "features/data/cookbooks_not_uploaded_at_feature_start"
     When I successfully run Knife's "cookbook upload version_updated"
     Then the output contains:
    """
    ERROR: Could not find cookbook version_updated in your cookbook path, skipping it

    """

  Scenario: Upload a Git managed cookbook with path to knife.rb created earlier
    Given the Knife file "foo/bar/.chef/knife.rb"
      And I cd to "./../../"
      And a Cookbook path "features/data/repositories/cookbooks_not_uploaded_at_feature_start/version_updated"
     When I successfully run Knife's "cookbook upload version_updated"
     Then the output contains "INFO: Uploading files"
      And the output contains "DEBUG: Committing sandbox"
      And the output contains "INFO: Upload complete!"

  Scenario: Verify a cookbook with path to knife.rb created earlier
    Given the Knife file "foo/bar/.chef/knife.rb"
    And I successfully run Knife's "cookbook show version_updated"
    And the output contains:
    """
    DEBUG: Signing the request as bobo-admin
    DEBUG: Sending HTTP Request via GET to localhost:4000/cookbooks/version_updated
    {
      "version_updated": [
        "2.0.0"
      ]
    }

    """

  Scenario: Delete a cookbook with path to knife.rb created earlier
    Given the Knife file "foo/bar/.chef/knife.rb"
     When I interactively run Knife's "cookbook delete version_updated"
      And I type "Y"
      And wait "5" seconds
     Then the output contains:
      """
      DEBUG: Signing the request as bobo-admin
      DEBUG: Sending HTTP Request via GET to localhost:4000/cookbooks/version_updated
      Do you really want to delete version_updated version 2.0.0? (Y/N) DEBUG: Signing the request as bobo-admin
      DEBUG: Sending HTTP Request via DELETE to localhost:4000/cookbooks/version_updated/2.0.0
      Deleted cookbook[version_updated version 2.0.0]!
      """

  Scenario: Auto upload and Delete a cookbook with path to knife.rb created earlier
    Given the Knife file "foo/bar/.chef/knife.rb"
      And I cd to "./../../"
      And a Cookbooks path "features/data/repositories/cookbooks_not_uploaded_at_feature_start"
     When I successfully run Knife's "cookbook upload version_updated"
      And I interactively run Knife's "cookbook delete version_updated 2.0.0"
      And I type "Y"
      And wait "5" seconds
     Then the output contains:
      """
      Do you really want to delete version_updated version 2.0.0? (Y/N) DEBUG: Signing the request as bobo-admin
      DEBUG: Sending HTTP Request via DELETE to localhost:4000/cookbooks/version_updated/2.0.0
      Deleted cookbook[version_updated version 2.0.0]!
      """