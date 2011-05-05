@announce
Feature: 02) Prepare Monitor VM
  In order to launch a Zenoss server
  As a admin/developer
  I want to define the VM configuration via executable features

  Background:
    Given the Chef root directory "/tmp/chef" exists
      And the state of VM "chef" is "running"
      And I switch Vagrant environment
      And the Chef root directory "/tmp/monitor" exists
      And the state of VM "monitor" is not "running"

  Scenario: Clone a Chef skeleton repository
    Given the remote Chef repository "git://github.com/cookbooks/chef-repo.git"
     When I clone the remote Chef repository branch "master" to "monitor"
      And the local Chef repository exists
     Then I place all in "monitor" in "/tmp/monitor"

  Scenario: Migrate the previously generated private keys
     Then I successfully run `cp /tmp/chef/.chef/monitor.pem /tmp/monitor/.chef`
      And I successfully run `cp /tmp/chef/.chef/monitor.pem /tmp/monitor/mnt/etc`

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
    And I place "hobos/vm.bo" in "/tmp/monitor"

    Scenario: Create the Monitor Node's Vagrantfile
     Given the file "Vagrantfile" contains nothing
      When I write to "Vagrantfile":
      """
      Vagrant::Config.run do |config|

        @cc_root_path = File.dirname(File.absolute_path(__FILE__))
        @cc_box_name  = "monitor"
        @cc_node_name = "monitor"
        @cc_box_url   = (Pathname(@cc_root_path) + 'lucid64.box').to_s
        @cc_ip        = "33.33.33.2"
        @cc_http_port = 48625
        @cc_ssh_port  = 48624
        @cc_chef_server_url     = "http://33.33.33.254:4000"
        @cc_host_mount          = "#{@cc_root_path}/mnt"
        @cc_chefserver_path     = Pathname(@cc_root_path).parent + 'chef'
        @cc_validation_key_path = "#{@cc_chefserver_path}/mnt/etc/validation.pem"

        config.vm.define :monitor do |cfg|

          cfg.send :eval, IO.read("#{@cc_root_path}/hobos/vm.bo")

          cfg.vm.box = @cc_box_name
          cfg.vm.box_url = @cc_box_url
          cfg.vm.boot_mode = :vrdp # :vrdp (headless) or :gui

          cfg.vm.network @cc_ip                           # host-only network IP
          cfg.vm.forward_port "http", 80, @cc_http_port   # Accessible outside the host-only network
          cfg.vm.forward_port "ssh", 22, @cc_ssh_port, :auto => true

          cfg.vm.share_folder("chef", "~/chef", "#{@cc_host_mount}/chef" )
          cfg.vm.share_folder( "chef-client-etc", "/etc/chef", "#{@cc_host_mount}/etc", :nfs => false ) # name, /vm/path, /real/path

          cfg.vm.provision :chef_server do |chef|
            chef.log_level = :debug
            chef.node_name = @cc_node_name
            chef.chef_server_url = @cc_chef_server_url
            chef.validation_key_path = @cc_validation_key_path
            chef.validation_client_name = "chef-validator"
            chef.client_key_path = "/etc/chef/monitor.pem"
          end
        end
      end
      """
       And I place "Vagrantfile" in "/tmp/monitor"
       And I run `bash -c 'cp ~/chef/vagrant/lucid64.box /tmp/monitor'`

    Scenario: Configure Knife file for the Monitor's client certificate
        Given the directory ".chef"
          And the file ".chef/knife.rb" contains:
              """
              current_dir = File.dirname(__FILE__)
              user = ENV['CHEF_USER'] || ENV['OPSCODE_USER'] || ENV['USER'] || `whoami`
              org = ENV['CHEF_ORGNAME'] || 'Private'
              email =  ENV['CHEF_EMAIL'] || "#{user}@mailinator.com"
              log_path = "#{current_dir}/../log"

              node_name                'monitor'
              chef_server_url          "http://localhost:4000"
              log_level                :debug
              log_location             "#{log_path}/client_#{node_name}.log"
              verbose_logging          true
              client_key               "#{current_dir}/#{node_name}.pem"
              cache_type               'BasicFile'
              cache_options            :path => "#{log_path}/checksums"
              cookbook_path            ["#{current_dir}/../cookbooks", "#{current_dir}/../site-cookbooks"]
              cookbook_copyright       user
              cookbook_license         "apachev2"
              cookbook_email           email

              # Amazon Web Services:
              knife[:aws_access_key_id]     = ENV['AWS_ACCESS_KEY']  if ENV['AWS_ACCESS_KEY']
              knife[:aws_secret_access_key] =  ENV['AWS_SECRET_KEY'] if ENV['AWS_SECRET_KEY']

              # Rackspace:
              knife[:rackspace_api_key]      = ENV['RS_API_KEY']      if ENV['RS_API_KEY']
              knife[:rackspace_api_username] = ENV['RS_API_USERNAME'] if ENV['RS_API_USERNAME']

              # Slicehost
              knife[:slicehost_password] = ENV['SH_PASSWORD'] if ENV['SH_PASSWORD']

              # Terremark
              knife[:terremark_password] = ENV['TM_PASSWORD'] if ENV['TM_PASSWORD']
              knife[:terremark_username] = ENV['TM_USERNAME'] if ENV['TM_USERNAME']
              knife[:terremark_service]  = ENV['TM_SERVICE']  if ENV['TM_SERVICE']

              """
        And I place ".chef/knife.rb" in "/tmp/monitor"
        And I place ".chef/knife.rb" in "/tmp/monitor/mnt/chef"


