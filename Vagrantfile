# -*- mode: ruby -*-
# vi: set ft=ruby :

# test if the host is a Windows box. If not, we'll set synced folders to use NFS for
# a (hopeful) performance increase
require 'rbconfig'
IS_WINDOWS = (RbConfig::CONFIG['host_os'] =~ /mswin|mingw|cygwin/) ? true : false

Vagrant.configure("2") do |config|
  # Box
  config.vm.box = "precise32"

  # Box URL
  config.vm.box_url = "http://files.vagrantup.com/precise32.box"

  # Shared folder
  config.vm.synced_folder "www", "/home/vagrant/www", :nfs => !IS_WINDOWS

  # Allows symlinks to be created in the shared folder.
  config.vm.provider :virtualbox do |v|
    v.customize ["setextradata", :id, "VBoxInternal2/SharedFoldersEnableSymlinksCreate/www", "1"]
    v.customize ["modifyvm", :id, "--cpus", "2"]
    v.customize ["modifyvm", :id, "--ioapic", "on"]
  end


  # Forwarded ports
  config.vm.network :forwarded_port, host: 3000, guest: 80 # apache
  config.vm.network :forwarded_port, host: 3333, guest: 3306 # mysql

  # We have to install build-essential separately from Chef provisioning so the mysql cookbook can compile native extensions
  config.vm.provision :shell, :inline => "sudo aptitude -y install build-essential"

  # Provisioning with Chef
  config.vm.provision :chef_solo do |chef|
      chef.cookbooks_path = "cookbooks"
      chef.roles_path = "roles"
      chef.add_role("base")
      chef.add_role("amp")
      chef.add_role("extras")

      chef.json.merge!({
        :phpapacheconf => {
          :hostname => 'project.local',
          :set_env => 'development',
          :docroot => '/home/vagrant/www/public'
        },
        :mysql => {
          :server_root_password => 'root',
          :server_debian_password => 'root',
          :server_repl_password => 'root'
        },
        :phpplugins => {
          :cypher => 'xV66(E1Ra+|]E3}_MKULXBh+mSP%6v8w[d6z6G[f'
        },
        :nodejs => {
          :version => '0.10.8',
          :npm => '1.2.23'
        }
      })
  end
end