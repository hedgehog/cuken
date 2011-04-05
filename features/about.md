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
As of 0.9.12 thru Chef 0.10 beta (latest at the time of writing),
Chef restricts the JSON gem to versions >= 1.4.4
and <= 1.4.6. Vagrant requires the JSON gem be version >= 1.5.1.
Unitl Chef updates it JSON version or moves to somthing else, we
have to workaround this.  This means compromise or introduce conditons.
Rather than compromise, I've chosen the condition that RVM be required,
and that you have a gemset named `vargant`, wiht just vagrant installed.
That's it.
Hopefully that wasn't too painful.

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