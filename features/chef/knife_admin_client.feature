#
# NOTE: This is an example of Cuken usage. Assuming:
# - A Chef server on localhost:4000 (point to yours)
# - An admin client named bobo exists on that Chef server
#
# If you wish to mock a Chef server, see the Chef project's
# features setup.
#
@announce @knife @steps
Feature: Reusable Chef Knife steps
  In order to write Chef features describing post-convergence system integration
  As a Chef user
  I want to describe features without having to implement Knife steps

  Background:
    Given the Chef server URI "http://localhost:4000"
    And the Chef admin client "bobo"
    Given a directory named "foo/bar"
    And a file named "foo/bar/bobo.pem" with:
    """
    -----BEGIN RSA PRIVATE KEY-----
    MIIEowIBAAKCAQEAumj8KuxHMNsIF00uMw2ZYfUj45vQD1OqhgjF2xAAlILMVeMP
    xt+Xqq5bm2LS2zDbwK0lAWDAJTr/PHRPt9+4rMlYZt9bZWcLy/AeHHc3XePzaPIZ
    Pctv7ja9Juom55PQRqmqviyw//9Usbnwx/9BAgPaq9lk3Cx0Ce+gRJLHkzXA0/bY
    m68XTTtSkfdruruy0Y8qDSHEX++08xA0MYTp6EY+BiyECPntv8itp/DoRL+cDgAt
    zuG0/Gn6EUMH2GGZ2K1bbA0l8xR8Jl+pE+w8teRWnJeuF1VxK6k0jnR8D7TzGJHc
    xmg0O/UJf7f6CYVA7schABkZfu/LUcGXSImK9wIDAQABAoIBADSdYV+0JTvy9sus
    6zdZxUtS5/hciFNrKByA6We1kpRYfthXKKLXhXWVlSG8uQtJNR2jQWisKE/Z4STt
    J3sc2IFcq2kN7jwm47uCYN1kAOqtZozemKVKgKNaK/WJ7cU7gXQQe7MF5ke7h+pK
    M14f+/dXoycSS1eh7HbJfhEc5Nv1ufpm+0anK+Ek1qKWVFSC5wrtMbnHb3TuIkE4
    W7cUHWFtnf1p6ZGDROooAOpbPLO7pmbO1idt6lR12/DUP5vgd4WzyRitGt0ra3X9
    htf12jMAaXVqAe1xKGFLi6p08CMTnv/7p/G+sK/HliBN4dpKMmhmFyDG1kEaXCIp
    abUd5oECgYEA9WHNfEs24CMfvNxw5Rrz176BwbFHolnjY9XpqoCB5jN+RhXzM2IR
    8r9jFwTGe7GucLB0DBOWh+8xNyPNtDleYggBWX36f85UFvpkvPwTAjvZHsgdHC4c
    EjnWyzgz+GL2glKXnJed/eBejVFHnHvVOkWz15X1CZmDEQAeQmU/5tcCgYEAwnnt
    DaECIYPxWaeBuYqP0AhyuvA/wHqb0HjsrS7spM1mvcyFDtcOMuSKFO4eEJW4Jybk
    fxaMnJdrL7kPWjT5e8OP0dFsMiNyXD1gWl8/+CysaYsVFNa4QJo/ZZKVSTCGgDk4
    8aOVyHB0KjLeDcf6aqe9aAr7amDrHoIqPT4wmOECgYA+x1HqLdgRSgsxp3hetSGT
    ndLWukNofvTVMwJAM/aH7b6tsanyCHItF9gDKJ6bQN8vR4W5HT3S81g1Ejzrkg3a
    qM+nlLqE/kW3R0KEsz0twiAPZwVDk2xtIU0Z2vw43SDSQM03K/co38FxCE149Jmd
    +f1D98KkPRkyPUSAmiTaKwKBgHiH7L3nrlRrXCg+ww3lrOA4fDMUN87prqx0Zeuo
    C47Qpv63RTg/XVN5hYMXWZbZ1DqfxjpmFVvwFMSNI9C6yG1GdVqLO02P3o8Akzkv
    k4wS1ADN7JDvy15uuyAOy2uDIblSvdI1mt2RpM2KnUlZSgDUWXWkaNIzo0VTUy6F
    3sTBAoGBAMCgw1dKF48GiKL5HYcwpbQrRneDX/l6w3sqNV8/UrzqJOm+elu/BT8y
    g1sug7qgWqOJYytk2hgGeiB/IGZNsR9Tw+270xLaQlUoqtraDoh6liAdjA3f4BWu
    9SJ/Of+9/IQ4lNXG36TAVUHnJ7hu5SGQkL3XUgNeotv1gCcZTvWW
    -----END RSA PRIVATE KEY-----
    """
    And a file named "foo/bar/.chef/knife.rb" with:
    """
    current_dir = File.dirname(__FILE__)
    log_level :debug
    log_location $stdout
    node_name "bobo"
    client_key "#{File.dirname(current_dir)}/bobo.pem"
    chef_server_url "http://localhost:4000"
    cache_type 'Memory'
    cache_options( :path => "#{ENV['HOME']}/.chef/checksums" )
    cookbook_path ["#{current_dir}/../cookbooks","#{current_dir}/../site-cookbooks"]

    """

  Scenario: Knife steps default knife.rb path
     Given I cd to "foo/bar"
      When I successfully run `knife node list`
      When the output should contain:
     """
     DEBUG: Using configuration from /usr/src/cuken/tmp/aruba/foo/bar/.chef/knife.rb
     DEBUG: Signing the request as bobo
     DEBUG: Sending HTTP Request via GET to localhost:4000/nodes
     [
     """

  Scenario: Knife steps with path to knife.rb created earlier
     Given the Knife file "foo/bar/.chef/knife.rb"
      When I successfully run Knife's "node list"
      When the output should contain:
     """
     DEBUG: Using configuration from /usr/src/cuken/tmp/aruba/foo/bar/.chef/knife.rb
     DEBUG: Signing the request as bobo
     DEBUG: Sending HTTP Request via GET to localhost:4000/nodes
     [
     """

  Scenario: Upload a cookbook with path to knife.rb created earlier
    Given the Knife file "foo/bar/.chef/knife.rb"
      And I cd to "./../../"
      And a cookbook path "features/data/cookbooks_not_uploaded_at_feature_start"
     When I successfully run Knife's "cookbook upload version_updated"
     Then the output should contain:
    """
    DEBUG: Signing the request as bobo
    DEBUG: Sending HTTP Request via PUT to localhost:4000/cookbooks/version_updated/2.0.0
    INFO: Upload complete!

    """

  Scenario: Verify a cookbook with path to knife.rb created earlier
    Given the Knife file "foo/bar/.chef/knife.rb"
    And I successfully run Knife's "cookbook show version_updated"
    And the output should contain:
    """
    DEBUG: Signing the request as bobo
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
     Then the output should contain:
      """
      DEBUG: Signing the request as bobo
      DEBUG: Sending HTTP Request via GET to localhost:4000/cookbooks/version_updated
      Do you really want to delete version_updated version 2.0.0? (Y/N) DEBUG: Signing the request as bobo
      DEBUG: Sending HTTP Request via DELETE to localhost:4000/cookbooks/version_updated/2.0.0
      Deleted cookbook[version_updated version 2.0.0]!
      """

  Scenario: Auto upload and Delete a cookbook with path to knife.rb created earlier
    Given the Knife file "foo/bar/.chef/knife.rb"
      And I cd to "./../../"
      And a cookbook path "features/data/cookbooks_not_uploaded_at_feature_start"
     When I successfully run Knife's "cookbook upload version_updated"
     When I successfully run Knife's "cookbook delete version_updated 2.0.0"
     Then the output should contain:
      """
      DEBUG: Signing the request as bobo
      DEBUG: Sending HTTP Request via GET to localhost:4000/cookbooks/version_updated
      Do you really want to delete version_updated version 2.0.0? (Y/N) DEBUG: Signing the request as bobo
      DEBUG: Sending HTTP Request via DELETE to localhost:4000/cookbooks/version_updated/2.0.0
      Deleted cookbook[version_updated version 2.0.0]!
      """