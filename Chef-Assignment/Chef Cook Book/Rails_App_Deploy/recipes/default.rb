#
# Cookbook Name:: Rails_App_Deploy
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.


apt_update 'Update the apt cache daily' do
  frequency 86_400
  action :periodic
end

package 'git-core'
package 'git'
package 'curl'
package 'zlib1g-dev'
package 'build-essential'
package 'libssl-dev'
package 'libreadline-dev'
package 'libyaml-dev'
package 'libsqlite3-dev'
package 'sqlite3'
package 'libxml2-dev'
package 'libxslt1-dev'
package 'libcurl4-openssl-dev'
package 'python-software-properties'
package 'libffi-dev'
package 'postgresql'
package 'postgresql-contrib'
package 'libpq-dev'
package 'nodejs'
package 'nginx'


directory '/root/.rbenv' do
  action :create
end
git '/root/.rbenv' do
  repository 'git://github.com/sstephenson/rbenv.git'
  revision 'master'
  action :sync
end


directory '/root/.rbenv/plugins' do
  action :create
end

directory '/root/.rbenv/plugins/ruby-build' do
  action :create
end
git '/root/.rbenv/plugins/ruby-build' do
  repository 'git://github.com/sstephenson/ruby-build.git'
  revision 'master'
  action :sync
end


directory '/root/chef_simple_rails_app' do
  action :create
end
git '/root/chef_simple_rails_app' do
  repository 'https://github.com/bsvin33t/simple_rails_app.git'
  revision 'master'
  action :sync
end

git '/root/.rbenv/plugins/rbenv-vars' do
  repository 'git://github.com/sstephenson/rbenv-vars.git'
  revision 'master'
  action :sync
end

service "postgresql" do
  supports :status => true
  action [:enable, :start]
end


bash 'install_enviornment' do
  user 'root'
  cwd '/root'
  code <<-EOH
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> /root/.bash_profile
echo 'eval "$(rbenv init -)"' >> /root/.bash_profile
echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> /root/.bash_profile
source /root/.bash_profile

rbenv install -v 2.2.3;
rbenv global 2.2.3;
ruby -v;
  EOH
end
bash 'install_gem' do
  user 'root'
  cwd '/root'
  code <<-EOH
source /root/.bash_profile
echo "gem: --no-document" > /root/.gemrc
gem install bundler
gem install rails
rbenv rehash
rails -v

sudo -u postgres createuser -s root
sudo -u postgres psql -U postgres -d postgres -c "alter user root with password 'password';"
EOH
end

bash 'setup_rails_app' do
  user 'root'
  cwd '/root/chef_simple_rails_app'
  code <<-EOH
source /root/.bash_profile
bundle
echo "SECRET_KEY_BASE=`rake secret`" > .rbenv-vars
rbenv vars
rake db:create
rake db:migrate
rake assets:precompile
RAILS_ENV=production rake db:create
RAILS_ENV=production rake db:migrate
RAILS_ENV=production rake assets:precompile
  EOH
end


file '/root/chef_simple_rails_app/config/puma.rb' do
  content 'workers 1
threads 1, 6
app_dir = File.expand_path("../..", __FILE__)
shared_dir = "#{app_dir}/shared"
rails_env = ENV[\'RAILS_ENV\'] || "production"
environment rails_env
bind "unix://#{shared_dir}/sockets/puma.sock"
stdout_redirect "#{shared_dir}/log/puma.stdout.log", "#{shared_dir}/log/puma.stderr.log", true
pidfile "#{shared_dir}/pids/puma.pid"
state_path "#{shared_dir}/pids/puma.state"
activate_control_app
on_worker_boot do
require "active_record"
ActiveRecord::Base.connection.disconnect! rescue ActiveRecord::ConnectionNotEstablished
ActiveRecord::Base.establish_connection(YAML.load_file("#{app_dir}/config/database.yml")[rails_env])
end'
end

directory '/root/chef_simple_rails_app/shared' do
  action :create
end

directory '/root/chef_simple_rails_app/shared/pids' do
  action :create
end

directory '/root/chef_simple_rails_app/shared/sockets' do
  action :create
end

directory '/root/chef_simple_rails_app/shared/log' do
  action :create
end

file '/etc/puma.conf' do
  content '/root/chef_simple_rails_app/'
end

file '/etc/nginx/sites-available/default' do
  content 'upstream app {
    # Path to Puma SOCK file, as defined previously
    server unix:/root/chef_simple_rails_app/shared/sockets/puma.sock fail_timeout=0;
}

server {
    listen 80;
    server_name 0.0.0.0;

    root /root/chef_simple_rails_app/public;

    try_files $uri/index.html $uri @app;

    location @app {
        proxy_pass http://app;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Host $http_host;
        proxy_redirect off;
    }

    error_page 500 502 503 504 /500.html;
    client_max_body_size 4G;
    keepalive_timeout 10;
}'
end

bash 'setup_nginx' do
  user 'root'
  cwd  '/'
  code <<-EOH
cp /root/.rbenv/versions/2.2.3/lib/ruby/gems/2.2.0/gems/puma-3.4.0/tools/jungle/upstart/puma.conf /etc/init/puma.conf
cp /root/.rbenv/versions/2.2.3/lib/ruby/gems/2.2.0/gems/puma-3.4.0/tools/jungle/upstart/puma-manager.conf /etc/init/puma-manager.conf
sed -i "s/setuid apps/setuid root/g" /etc/init/puma.conf
sed -i "s/setgid apps/setgid root/g" /etc/init/puma.conf
sed -i "s/user www-data/user root/g" /etc/nginx/nginx.conf
sudo stop puma app=/root/chef_simple_rails_app/;
sudo start puma app=/root/chef_simple_rails_app/;
service nginx restart;
  EOH
end
