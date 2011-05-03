@announce
Feature: 01) Chef-Server VM
  In order to launch a Zenoss server
  As a admin/developer
  I want to define the Chef admin client configuration via executable features

  Scenario: Create the Chef server Node's Vagrantfile
   Given the file "Vagrantfile" contains nothing
    When I write to "Vagrantfile":
    """
    Vagrant::Config.run do |config|

      @cs_root_path      = File.dirname(File.absolute_path(__FILE__))
      @cs_box            = "chef"
      @cs_box_url        = (Pathname(@cs_root_path) + 'lucid64.box').to_s
      @cs_nodename       = "chef"
      @cs_tld            = "private.org"
      @cs_ip             = "33.33.33.254"   # Host-only networking
      @cs_port           = 4000
      @cs_ssh_port       = 2200
      @cs_webui_port     = 4040
      @cs_kitchen        = @cs_root_path
      @cs_validation_client_name = "chef-validator"

      config.vm.define :chef do |csc|

        csc.send :eval, IO.read("#{@cs_root_path}/hobos/vm.bo")

        csc.vm.box = "#{@cs_box}"
        csc.vm.box_url = "#{@cs_box_url}"
        csc.vm.forward_port("chefs", @cs_port, @cs_port)
        csc.vm.forward_port("chefs_web", @cs_webui_port, @cs_webui_port)
        csc.vm.forward_port("ssh", 22, @cs_ssh_port, :auto => true)
        csc.vm.network(@cs_ip)
        csc.vm.share_folder("chef", "~/chef", "#{@cs_root_path}/mnt/chef")
        csc.vm.share_folder("chef-server-etc", "/etc/chef", "#{@cs_kitchen}/mnt/etc" )
        csc.vm.share_folder("chef-cookbooks-0", "/tmp/vagrant-chef/cookbooks-0", "#{@cs_kitchen}/site-cookbooks")
        csc.vm.share_folder("chef-cookbooks-1", "/tmp/vagrant-chef/cookbooks-1", "#{@cs_kitchen}/cookbooks")
        csc.vm.provision :chef_solo do |chef|
          chef.log_level = :debug # :info or :debug
          chef.node_name = @cs_nodename
          chef.cookbooks_path = [
              File.expand_path("#{@cs_kitchen}/site-cookbooks"),
              File.expand_path("#{@cs_kitchen}/cookbooks")]
          chef.add_recipe("hosts::chefserver")
          chef.add_recipe("apt")
          chef.add_recipe("build-essential")
          chef.add_recipe("chef-server::rubygems-install")
          chef.json.merge!({
              :chef_server=> {
              :name=> @cs_nodename,
              :validation_client_name=> @cs_validation_client_name,
              :url_type=>"http",
              :server_fqdn=> "#{@cs_nodename}.#{@cs_tld}",
              :server_port=> "#{@cs_port}",
              :webui_port=> "#{@cs_webui_port}",
              :webui_enabled=> true,
              :umask => '0644'
             }
            })
        end
      end
    end
    """
    Then I place "Vagrantfile" in "/tmp/chef"

  Scenario: Create some shared Vagrant configuration details
    Given the directory "hobos"
      And the file "hobos/vm.bo" contains nothing
     When I write to "hobos/vm.bo":
      """
      vm.customize do |cvm|
        cvm.memory_size = 1024
        cvm.vram_size = 12
        cvm.cpu_count = 2
        cvm.accelerate_3d_enabled = false
        cvm.accelerate_2d_video_enabled = false
        cvm.monitor_count = 1

        cvm.bios.acpi_enabled = true
        cvm.bios.io_apic_enabled = false

        cvm.cpu.pae = true

        cvm.hw_virt.enabled = false
        cvm.hw_virt.nested_paging = false
        # STORAGE
      end
      """
    And I place "hobos/vm.bo" in "/tmp/chef"

  Scenario: Clone a Chef skeleton repository
    Given the remote Chef repository "git://github.com/cookbooks/chef-repo.git"
     When I clone the remote Chef repository branch "master" to "chef"
      And the local Chef repository exists
     Then I place all in "chef" in "/tmp/chef"

  Scenario: Download Cookbooks from a Cookbooks URI
    Given the remote Cookbooks URI "git://github.com/cookbooks/"
     When I clone the Cookbooks:
          | cookbook         | branch | destination                    |
          | apache2          | master | chef/cookbooks/apache2         |
          | apt              | master | chef/cookbooks/apt             |
          | bluepill         | master | chef/cookbooks/bluepill        |
          | build-essential  | master | chef/cookbooks/build-essential |
          | chef-client      | master | chef/cookbooks/chef-client     |
          | chef-server      | master | chef/cookbooks/chef-server     |
          | couchdb          | master | chef/cookbooks/couchdb         |
          | daemontools      | master | chef/cookbooks/daemontools     |
          | erlang           | master | chef/cookbooks/erlang          |
          | gecode           | master | chef/cookbooks/gecode          |
          | hosts            | master | chef/cookbooks/hosts           |
          | java             | master | chef/cookbooks/java            |
          | openssl          | master | chef/cookbooks/openssl         |
          | rabbitmq         | master | chef/cookbooks/rabbitmq        |
          | runit            | master | chef/cookbooks/runit           |
          | ucspi-tcp        | master | chef/cookbooks/ucspi-tcp       |
          | xml              | master | chef/cookbooks/xml             |
          | zlib             | master | chef/cookbooks/zlib            |
      And these local Cookbooks exist:
         | cookbook         |
         | apache2          |
         | apt              |
         | bluepill         |
         | build-essential  |
         | chef-client      |
         | chef-server      |
         | couchdb          |
         | daemontools      |
         | erlang           |
         | gecode           |
         | hosts            |
         | java             |
         | openssl          |
         | rabbitmq         |
         | runit            |
         | ucspi-tcp        |
         | xml              |
         | zlib             |
     Then I place all in "chef" in "/tmp/chef"

  Scenario: Download Site-Cookbooks from a Cookbooks URI
    Given the remote Cookbooks URI "git@github.com:hedgehog/"
     When I clone the Cookbooks:
         | cookbook         | branch | destination               |
         | hosts            | qa     | chef/site-cookbooks/hosts |
         | java             | qa     | chef/site-cookbooks/java  |
      And these local Cookbooks exist:
         | site-cookbook    |
         | hosts            |
         | java             |
     Then I place all in "chef" in "/tmp/chef"

  Scenario: Configure Knife file for the Chef administrator's client certificate
      Given I write to ".chef/knife.rb":
    """
    current_dir = File.dirname(__FILE__)
    user = ENV['CHEF_USER'] || ENV['OPSCODE_USER'] || ENV['USER'] || `whoami`
    org = ENV['CHEF_ORGNAME'] || 'Private'
    email =  ENV['CHEF_EMAIL'] || "#{user}@mailinator.com"
    log_path = "#{current_dir}/../log"

    current_dir = File.dirname(__FILE__)
    node_name                "chef-webui"
    log_location             "#{log_path}/client_#{node_name}.log"
    log_level                :debug
    verbose_logging          true
    client_key               "#{File.dirname(current_dir)}/mnt/etc/webui.pem"
    chef_server_url          "http://localhost:4000"
    cache_type               'BasicFile'
    cache_options            :path => "#{log_path}/checksums"
    cookbook_path ["#{current_dir}/../cookbooks","#{current_dir}/../site-cookbooks"]

    """
     And I place ".chef/knife.rb" in "/tmp/chef"

  Scenario: Start the Chef server VM
    Given the Chef root directory "/tmp/chef" exists
      And the state of VM "chef" is not "running"
      And the Vagrantfile "/tmp/chef/Vagrantfile" exists
     When I launch the VM "chef"
     Then the state of VM "chef" is "running"

  @ssh_local
  Scenario: Fix the Chef server key/certificate permissions
    Given the Chef root directory "/tmp/chef" exists
      And the Vagrantfile "/tmp/chef/Vagrantfile" exists
      And the state of VM "chef" is "running"
     When I ssh to VM "chef"
      And I type "sudo chmod 0644 /etc/chef/webui.pem"
      And I type "sudo chmod 0644 /etc/chef/certificates/key.pem"
      And I type "stat -c %A /etc/chef/webui.pem"
      And I type "stat -c %A /etc/chef/certificates/key.pem"
     Then the output should contain:
          """
          -rw-r--r--
          -rw-r--r--
          """

  Scenario: Create the admin client monitor
    Given the Chef root directory "/tmp/chef" exists
      And the state of VM "chef" is "running"
     When I create the Chef admin client "monitor"
     Then the placed file "/tmp/chef/.chef/monitor.pem" contains "-----END RSA PRIVATE KEY-----"

