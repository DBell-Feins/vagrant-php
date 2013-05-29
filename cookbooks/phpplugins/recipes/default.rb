include_recipe "apache2"
include_recipe "apache2::mod_php5"
include_recipe "php"

require 'fileutils'

#php5 curl
package "php5-curl" do
  action :install
end

#php5 mysql
package "php5-mysql" do
  action :install
end

#php5 memcache
package "php5-memcache" do
  action :install
end

#php5 xsl
package "php5-xsl" do
  action :install
end

# xdebug package
package "php5-xdebug" do
  action :install
end

# mcrypt package
package "php5-mcrypt" do
  action :install
end

# imagemagick package
package "php5-imagick" do
  action :install
end

# memcached
package "memcached"

# Set up PHP packages.
php_pear_channel "pear.php.net" do
  action :update
end

phpunit = php_pear_channel "pear.phpunit.de" do
  action :discover
end

phpdoc = php_pear_channel "pear.phpdoc.org" do
  action :discover
end

# Run PEAR upgrade
php_pear "PEAR" do
  action    :upgrade
  options   "--force"
end

# phpDocumentor
php_pear "phpDocumentor" do
  channel          phpdoc.channel_name
  preferred_state  "alpha"
  action           :install
  options          "--alldeps"
end

# install PHPUnit
php_pear "PHPUnit" do
  channel          phpunit.channel_name
  preferred_state  "beta"
  action           :install
  options          "--alldeps"
end

# install git
package "git-core"

# phpMyAdmin
script "install_phpmyadmin" do
  interpreter "bash"
  user "root"
  cwd "/tmp"
  code <<-EOH
  rm -rf /tmp/phpMyAdmin*

  wget http://downloads.sourceforge.net/project/phpmyadmin/phpMyAdmin/4.0.2/phpMyAdmin-4.0.2-english.tar.gz
  tar -xzvf phpMyAdmin-4.0.2-english.tar.gz

  mkdir -p /var/www/phpmyadmin
  cp -R /tmp/phpMyAdmin-4.0.2-english/* /var/www/phpmyadmin/
  mysql --user=root --password=#{node['mysql']['server_root_password']} < /var/www/phpmyadmin/examples/create_tables.sql
  EOH
  not_if "test -f /var/www/phpmyadmin"
end

mysql_database_user "pma" do
  connection ({ :host => "localhost", :username => "root", :password => node['mysql']['server_root_password'] })
  password "pmapass"
  database_name "phpmyadmin"
  privileges [:all]
  action :grant
end

template "/var/www/phpmyadmin/config.inc.php" do
  source "config.inc.php.erb"
  owner "root"
  group "root"
  mode 0644
  variables({
    :cypher => node['phpplugins']['cypher']
    })
end


# sqlbuddy
script "install_sqlbuddy" do
  interpreter "bash"
  user "root"
  cwd "/tmp"
  code <<-EOH
  rm -rf /tmp/sqlbuddy*

  git clone https://github.com/calvinlough/sqlbuddy.git sqlbuddy
  mkdir -p /var/www/sqlbuddy
  cp -R /tmp/sqlbuddy/* /var/www/sqlbuddy/

  EOH
  not_if "test -f /var/www/sqlbuddy"
end

# capistrano
script "install_capistrano" do
  interpreter "bash"
  user "root"
  cwd "/tmp"
  code <<-EOH
  gem sources -a http://gems.github.com/
  gem install capistrano
  gem install railsless-deploy
  gem install capistrano-ext
  EOH
end

service 'apache2' do
  action :restart
end
