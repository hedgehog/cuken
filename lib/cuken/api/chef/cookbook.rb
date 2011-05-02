module ::Cuken
  module Api
    module Chef
      module Cookbook

        def parse_to_cookbooks_path(hsh)
          case
            when not(hsh['cookbook'].nil? || hsh['cookbook'].empty?)
              ckbk = hsh['cookbook']
              ckbk_src = "cookbooks/#{ckbk}"
            when not(hsh['site-cookbook'].nil? || hsh['site-cookbook'].empty?)
              ckbk = hsh['site-cookbook']
              ckbk_src = "site-cookbooks/#{ckbk}"
            else
              src =""
          end
          return ckbk, ckbk_src
        end

        def check_cookbooks_table_presence(table, expect_presence = true)
          table.hashes.each do |hsh|
            ckbk, ckbk_src = parse_to_cookbooks_path(hsh)
            full_cookbook_src = find_path_in_cookbook_folders(ckbk, ckbk_src, ckbk)
            announce_or_puts(%{Looking for cookbook: #{full_cookbook_src}}) if @announce_env
            check_cookbook_presence(full_cookbook_src, expect_presence)
          end
        end

        def find_path_in_cookbook_folders(ckbk, ckbk_src, path_fragment1, path_fagment2='')
          verify_cookbook_folders
          full_data_bag_src = nil
          in_chef_root do
            list1 = chef.cookbooks_paths.find_all { |dir| Pathname(dir + path_fragment1 + path_fagment2).exist? }
            list2 = chef.cookbook_paths.find_all { |dir| (dir.to_s[/#{ckbk_src}/] && Pathname(dir+path_fagment2).exist?) }
            loc = list2[0] || ((list1[0] + ckbk) if list1[0].exist?)
            if loc.nil? || not(loc.exist?)
              # TODO: error handling if data bags or cookbooks do not exist
            else
              full_data_bag_src = (loc + path_fagment2).expand_path.realdirpath.to_s
            end
          end
          full_data_bag_src
        end

        def verify_cookbook_folders
          if (chef.cookbooks_paths.empty? && chef.cookbook_paths.empty?)
            check_default_cookbooks_paths
          end
        end

        def check_default_cookbooks_paths
          in_chef_root do
            ['site-cookbooks', 'cookbooks'].each do |dir|
              path = (Pathname('.')+dir)
              chef.cookbooks_paths << path if path.exist?
            end
            if chef.cookbooks_paths.empty?
              raise(RuntimeError, "chef.cookbooks_paths AND chef.cookbook_paths cannot both be empty.", caller)
            end
            chef.cookbooks_paths.uniq
          end
        end

        def check_cookbook_presence(ckbk, expect_presence = true)
          chef.cookbook_paths.each do |pn|
            curr_ckbk = pn.basename.to_s
            condition = Pathname(pn).exist?
            given_ckbk = Pathname(ckbk).basename.to_s
            result = given_ckbk == curr_ckbk
            if condition && result
              given_ckbk.should == curr_ckbk
              announce_or_puts(%{Found cookbook: #{pn}}) if @announce_env
            end
          end
        end

      end
    end
  end
end

