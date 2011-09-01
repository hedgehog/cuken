#require 'aruba/api' unless defined? Aruba::Api
require 'cuken/api/ssh-forever'  unless defined? SecureShellForever

module Cuken
  module Api
    module Ssh

      def ssh_init_password_less
        @ssh_options ||= ssh_default_options
        cmd = ssh_cmd(@ssh_options)
        announce_or_puts(unescape(cmd))
      end

      def ssh_init_password_less_batch(table=nil)
        if table == :default
          return @ssh_options = ssh_default_options
        elsif table.nil?
          return @ssh_options ||={}
        end
        @ssh_options ||={}
        table.hashes.each do |hash|
          hsh = parse_ssh_options(hash)
          cmd = ssh_cmd(hsh)
          ssh_run(cmd)
        end
      end

      def ssh_init_password_less_interactive(table=nil)
        if table == :default
          return @ssh_options = ssh_default_options
        elsif table.nil?
          return @ssh_options ||={}
        end
        @ssh_options ||={}
        table.hashes.each do |hash|
          hsh = parse_ssh_options(hash)
          cmd = ssh_cmd(hsh)
          ssh_login_interactive(cmd)
        end
      end

      def ssh_run(cmd)
        run_simple(unescape(cmd))
      end

      def ssh_login_interactive(cmd)
        run_interactive(unescape(cmd))
      end

      def ssh_forever_init_password_less_batch(table=nil)
        if table == :default
          return @ssh_forever_options = ssh_forever_default_options
        elsif table.nil?
          return @ssh_forever_options ||={}
        end
        table.hashes.each do |hash|
          hsh = parse_ssh_forever_options(hash)
          cmd = ssh_forever(hsh)
          run_simple(unescape(cmd))
        end
      end

      def ssh_forever_options(table=nil)
        if table == :default
          return @ssh_forever_options = ssh_forever_default_options
        elsif table.nil?
          return @ssh_forever_options ||={}
        end
        table.hashes.each do |hash|
          hsh = parse_ssh_forever_options(hash)
          cmd = ssh_forever(hsh)
          run_simple(unescape(cmd))
        end
      end

      def ssh_client_hostname(n=nil)
        name = ENV['HOSTNAME']|| ENV['HOST']||ENV['COMPUTERNAME']||ENV['COMPUTER']||(`hostname`).strip rescue 'localhost'
        if @ssh_forever_options
          @ssh_forever_options[:user] = n.nil? ? name : n
        end
        name
      end

      def ssh_client_username(n=nil)
        name = ENV['USER']|| ENV['USERNAME']|| (`whoami`).strip rescue 'root'
        if @ssh_forever_options
          @ssh_forever_options[:hostname] = n.nil? ? name : n
        end
        name
      end

      private

      def ssh_forever(hsh)
        "ssh-forever #{hsh[:user]}@#{hsh[:hostname]} -p #{hsh[:port]} -i ~/.ssh/id_rsa_cuken -n #{hsh[:name]} -b"
      end

      def ssh_cmd(hsh)
        if hsh[:alias]
          #append_ssh_config unless existing_ssh_config?
          login_command = "ssh #{hsh[:alias]} #{ssh_args(hsh)}"
        else
          login_command = "ssh #{hsh[:user]}@#{hsh[:hostname]}#{ssh_args(hsh)}"
        end
        login_command
      end

      def ssh_args(hsh)
        [ ' ',
          ("-i #{hsh[:identity_file]}" if hsh[:identity_file]),
          ("-F #{hsh[:config_file]}" if hsh[:config_file]),
          ("-p #{hsh[:port]}" if hsh[:port] =~ /^\d+$/),
          (hsh[:stricthostkeychecking] == 'yes' ? "-o stricthostkeychecking=yes" : "-o stricthostkeychecking=no"),
          (hsh[:debug] ? "-vvv" : "-q")
        ].compact.join(' ')
      end

      def parse_ssh_forever_options(hsh)
        new_hsh = hsh.inject({}) { |h, (k, v)| h[k.intern] = v; h }
        ssh_forever_default_options.merge(new_hsh).inject({}) do |h, (k, v)|
          v=v.to_s
          if v[/\:default/]
            v = ssh_forever_default_options[k.to_sym]
            h[k]=v
            next h
          end
          if v[/`(.*)`/]
            cmd=v.gsub(/`/,'')
            run_simple(unescape(cmd))
            v = output_from(cmd).strip
          end
          h[k]=v
          h
        end
      end

      def parse_ssh_options(hsh)
        new_hsh = hsh.inject({}) { |h, (k, v)| h[k.intern] = v; h }
        ssh_default_options.merge(new_hsh).inject({}) do |h, (k, v)|
          v=v.to_s
          if v[/\:default/]
            v = ssh_default_options[k.to_sym]
            h[k]=v
            next h
          end
          if v[/`(.*)`/]
            cmd=v.gsub(/`/,'')
            run_simple(unescape(cmd))
            v = output_from(cmd).strip
          end
          h[k]=v
          h
        end
      end

      def ssh_forever_default_options
        {:user => ssh_client_username, :hostname => ssh_client_hostname,
        :port => 22, :name => 'cuken', :identity_file => '~/.ssh/id_rsa_cuken',
        :auto => true, :intense => true, :quiet => true }
      end

      def ssh_default_options
        {:user => ssh_client_username, :hostname => ssh_client_hostname,
        :port => 22, :identity_file => '~/.ssh/id_rsa',
        :quiet => true }
      end
    end
  end
end
