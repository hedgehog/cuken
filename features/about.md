# About Cuken's Reusable Steps

These [Cucumber][0] features summarise the steps defined in
[Cuken][1] and [Aruba][2]. Cuken's step+API structure is modeled on Aruba, and
largely uses Aruba's steps and API.

Cucumber features where these steps might be useful have been variously described as:
- Infrastructure integration tests
- Post-convergence system integration
- Agile Systems Administration/ SysAdmin Testing

Cuken grew out of refactoring the [Cucumber-Nagios][3] library.
The example features are executable documentation for usage of Cuken.
The SSH steps assume passwordless logins are accepted on `localhost:22`.
The Chef steps assume you have Chef server accessible on `localhost:4040`.

If you have ideas to clarify or improve any of these cucumber features,
please submit an [issue][9] or [pull request][8].

## The Chef JSON Issue
Due to several JSON gem conflicts between various gems, Cuken is only intended
to work with the 0.10 series of Chef.  Of course you are free to work whatever
magic you wish.

## Opinons
Virtual machines are [Vagrant][11] VM's.
Vagrant VM's are all named.
Configuration management and system integration is done with [Opscode's Chef][12].
Chef Cookbooks are sourced from the the [Cookbooks account][13] on Github.

## Conventions
Rather than repeatedly refer to Chef and Vagrant in step definitions, where it is unambiguous,
we simply treat the item or attribute as the pro-noun, and capitalize it.
Examples:

    Given the VM "chef" is not running
    Given I create the Data Bag "user"

Aruba will timeout if a command takes too long.  A convention is to tag Features/Scenarios
according to the size of the timeout threshold:

    no tag:  3 seconds (Aruba default)
    @slow
    @glacial
    @cosmic

Aruba will timeout if IO takes too long.  This affects interactive SSH connections.

    no tag:      0.1 seconds (Aruba default)
    @ssh_local
    @ssh_remote
    @ssh_pigeon

The default before blocks are in some of the Cucumber files. Example:

    ./lib/cuken/cucumber/chef.rb

If you need to change a default, add to your features/support/env.rb:

    Before do
      @aruba_timeout_seconds.nil? || @aruba_timeout_seconds < 3 ? @aruba_timeout_seconds = 3 : @aruba_timeout_seconds
    end

    Before('@glacial') do
      @aruba_timeout_seconds.nil? || @aruba_timeout_seconds < 3600 ? @aruba_timeout_seconds = 3600 : @aruba_timeout_seconds
    end


## Step contributions:
- Ideally the API methods should be covered by RSpec (I've been slack
on this simply because I'm trying to get over the initial backlog of
steps to port).
- Have a feature/scenario that illustrates its use.

## Prior Art:
- [Aruba][2] confirmed the utility of reusable steps.
- [Auxesis' Cucumber-Nagios][4] served as launch pad, and [had this idea early on][10].
- [Chef][5] steps are being ported.
- [Virtualbox][6] steps are planned to be ported.
- [SSH-Forever][7] serves as the API-base for passwordless SSH steps.

[0]: https://github.com/aslakhellesoy/cucumber
[1]: https://github.com/hedgehog/cuken
[2]: https://github.com/aslakhellesoy/aruba
[3]: https://github.com/hedgehog/cucumber-nagios
[4]: https://github.com/auxesis/cucumber-nagios
[5]: https://github.com/opscode/chef
[6]: https://github.com/mitchellh/virtualbox
[7]: https://github.com/mattwynne/ssh-forever
[8]: http://help.github.com/pull-requests
[9]: https://github.com/hedgehog/cuken/issues
[10]: http://groups.google.com/group/agile-system-administration/msg/4128b2de36ccf899
[11]: http://vagrantup.com/
[12]: http://wiki.opscode.com/display/chef/Home
[13]: https://github.com/cookbooks/
