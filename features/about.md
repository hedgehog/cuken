# About Cuken's Reusable Steps

These [Cucumber][0] features summarise the steps defined in
[Cuken][1] and [Aruba][2]. Cuken's step+API structure is modeled on Aruba.

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

## The Zenoss Example
This is a proof of concept rather than best practice example.
It is modeled on Matt Ray's blip.tv [screencast][17].  The intention is that you read, adjust and then run the features
in the numbered order.
Some things to adjust are the writable GitHub URI's, and the location of the Vagrant basebox.
In the final version all examples should 'just-run', until then, or until you make a pull request to change it,
it is more convenient for me.

## The Chef vs Vagrant/Aruba JSON Issue
Due to several JSON gem conflicts between Chef and the Vagrant/Aruba gems, Cuken is only intended
to work with the 0.10 series of Chef.  Of course you are free to work whatever
magic you wish for the 0.9.x releases.

## Opinons
Cuken is an 'Opinionated library':
Virtual machines are [Vagrant][11] VM's.
Vagrant VM's are all named.
Configuration management and system integration is done with [Opscode's Chef][12].
Chef Cookbooks are sourced from the [Cookbooks account][13] on Github.

## Multiple Vagrant Multi-VM Environemts in one Scenario
Vagrant allows you to have Multi-VM environemnts in one Vagrantfile.
Cuken allows you to have multiple Vangrant Multi-VM environments in one scenario.
However there can be a performance penalty, so use this judiciously.  To illustrate the performance hit
the Zenoss example (02_monitor_vm_setup.rb) has a multiple Vagrant environment as a Background - this gets run before
each scenario.  This example also serves to demonstrate the steps neccessary to switch between Vagrant environments
(Vagrantfiles).  Note the convention is that the Vagrant file resides in the Chef-project root directory.

  Background:
    Given the Chef root directory "/tmp/chef" exists
      And the state of VM "chef" is "running"
      And I switch Vagrant environment
      And the Chef root directory "/tmp/monitor" exists
      And the state of VM "monitor" is not "running"

NOTE:
The Zenoss example is intended to exercise steps and illustrate some useage.
It is certainly not an illustrattion of best practice.

## Conventions

### Generic
Rather than repeatedly refer to Chef, Vagrant, etc. in each step, where it is unambiguous,
we treat the item or attribute as a pronoun, but capitalize to indicate the specialized substitution.
So, while there are many virtual machines and data bags in the world, here they refer to
Vagrant (VirtualBox) and Chef.

Examples:

    Given the state of VM "chef" is not "running"
    Given I create the Data Bag "user"

### Place and Placed Files and Folders
The convention is to carry out all file and folder CRUD inside Aruba's scratch directory.
Given that Aruba deletes its tmporary working folder at the start of each scenario, it is  neccessary to transfer any
files and folders you wish to keep.
We refer to this transfer of files and folders as 'placing'.  Since a copy does not exists beyond the Scenario's life,
and since we verify the contents of placed files, it is not a file or folder copy nor move.
Placing and placed files and folders refer to taking a file from Aruba's scratch folder, moving it
outside of that ephemeral area and verifying the contents.

### Chef
In most cases Chef operations refer to the remote server, e.g. 'I create the Data Bag "...".  The reason we leave remote
implicit in these steps, are:

 a) to keep steps descriptions succint yet informative/accurate.
 b) a 'local' version of this step is not accurate because local, filesystem, operations are properly done with the file
and directory steps and API, and are not done through Chef/Knife.

Cookbooks are are checked out into the branch 'cuken'.
Once you are happy with your changes, you can [rebase][14] ([interactively][15]) then push your changes to your fork
There are other ways, here is one [Git ver. 1.7.5]):

    git checkout cuken  # Just in case. Cuken leaves this branch checked-out
    git rebase qa
    git push origin qa

Then, on Github, issue a pull request from the qa branch of your fork.
To see a listing of the changes (before you rebase): `git diff qa..cuken`

### Vagrant
The Vagrantfile is required to be in the Chef-project root directory.  Consequently the step
'the Chef root directory "/tmp/chef" exists' is required before any Vagrant steps.

## Hooks
If you need to change a default hook, add your variation of the following to your project's features/support/env.rb:

    Before do
      @aruba_timeout_seconds.nil? || @aruba_timeout_seconds < 3 ? @aruba_timeout_seconds = 3 : @aruba_timeout_seconds
    end

    Before('@glacial') do
      @aruba_timeout_seconds.nil? || @aruba_timeout_seconds < 3600 ? @aruba_timeout_seconds = 3600 : @aruba_timeout_seconds
    end

    Before('@ssh_local') do
      @aruba_io_wait_seconds.nil? || @aruba_io_wait_seconds < 0.3 ? @aruba_io_wait_seconds = 0.3 : @aruba_io_wait_seconds
    end

### Aruba
Aruba will timeout if a command takes too long.  A convention is to tag Features/Scenarios
according to the size of the timeout threshold:
See lib/cuken/vagrant/hooks.rb:

    no tag:  3 seconds (Aruba default)
    @fast    6 seconds
    @quick   20 seconds
    @slow    60 seconds
    @glacial 600 seconds
    @cosmic  3600 seconds

Aruba will timeout if IO takes too long.  This affects interactive SSH connections.
See lib/cuken/ssh/hooks.rb:

    no tag:      0.1 second (Aruba default)
    @ssh_local   0.3 second
    @ssh_remote  1 second
    @ssh_pigeon  3 seconds
    @ssh_dodo    10 seconds

### Git/Grit
See lib/cuken/git/hooks.rb:

    no tag:  10 seconds (Grit default)
    @git_quick   20 seconds
    @git_slow    60 seconds
    @git_glacial 600 seconds
    @git_cosmic  3600 seconds

## Gotcha's
Unicorns are a dream, but Dragons are real...
### Aruba
Aruba doesn't yet handle generic script execution, and that includes Bash and friends.  There is some support for Ruby.
No trouble, you just need to use this syntax, if you want to fix it, see [here][16]:

    And I run `bash -c 'cp ~/chef/vagrant/lucid64.box /tmp/monitor'`

## API and Step contributions:
- Ideally the API methods should be covered by RSpec (I've been slack due to the backlog of pre-existing steps to port).
- Have a feature/scenario that illustrates its use, this is the psuedo specs I've been relying on.  If you are not
convinced this approach is a long term disaster, review Bundler's code base circa v1.0.10.
- Refactoring an API method is discouraged before a spec fully describing the current behavior exists.

## TODO
- General passwordless and interactive SSH steps (currently Vagrant VM specific)
- Cloud launch and basic management steps, i.e. CRUD operations for Cloud VM
- Updating packages on a VM, and repackaging the VM, essentialy CRUD too.
- Remove 'should' from steps
- Make output steps expression consistent with file/directory steps

## Prior Art:
- [Aruba][2] confirmed the utility of reusable steps.
- [Auxesis' Cucumber-Nagios][4] served as launch pad, and [had this idea early on][10].
- [Chef][5] steps are being ported.
- [Virtualbox][6] steps are planned to be ported.
- [SSH-Forever][7] copied as the API-base for passwordless SSH steps.

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
[14]: http://book.git-scm.com/4_rebasing.html
[15]: http://book.git-scm.com/4_interactive_rebasing.html
[16]: https://github.com/aslakhellesoy/aruba/issues/69
[17]: http://blip.tv/file/4687890
