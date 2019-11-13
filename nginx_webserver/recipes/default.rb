apt_update 'Update the apt cache daily' do
  frequency 86_400
  action :periodic
end

package 'git'
package 'tree'

package 'nginx' do
  action :install
end

group node['nginx']['config']['group']

user node['nginx']['config']['user'] do
  shell '/bin/nologin'
  group node['nginx']['config']['group']
end

service 'nginx' do
  supports status: true, restart: true, reload: true
  action [ :enable, :start ]
end

template "/var/www/html/#{node['nginx']['config']['home_page']}" do
  # action :create_if_missing
  source 'index.html.erb'
  mode node['nginx']['config']['mode']
  owner node['nginx']['config']['owner']
  group node['nginx']['config']['group']
  notifies :reload, 'service[nginx]', :delayed
end

template node['nginx']['config']['config_dir'] do
  source 'nginx.conf.erb'
  notifies :reload, 'service[nginx]'
end
