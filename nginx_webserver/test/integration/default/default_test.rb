control 'nginx_conf_001' do
  impact 0.8
  title 'nginx_conf'
  desc 'check if nginx package is installed'
  tag 'nginx'

  describe package('nginx') do
    it { should be_installed }
  end
end

control 'nginx_conf_002' do
  impact 0.8
  title 'nginx_conf'
  desc 'check if nginx service is enabled and running'
  tag 'nginx'

  describe service('nginx') do
    it { should be_installed }
    it { should be_enabled }
    it { should be_running }
  end
end

control 'nginx_conf_003' do
  impact 0.8
  title 'nginx_conf'
  desc 'check if port is listening'
  tag 'nginx'

  describe group('nginx') do
    it { should exist }
  end

  describe user('nginx') do
    it { should exist }
    its('group') { should eq 'nginx' }
  end
end

control 'nginx_conf_004' do
  impact 0.8
  title 'nginx_conf'
  desc 'check if port is listening'
  tag 'nginx'

  describe port(80) do
    it { should be_listening }
    its('protocols') { should include 'tcp' }
  end

  describe port(22) do
    it { should be_listening }
    its('protocols') { should include 'tcp' }
  end
end

control 'nginx_conf_005' do
  impact 0.8
  title 'nginx_conf'
  desc 'check if the template is in the right location and has the required content'
  tag 'nginx'

  describe file('/var/www/html/index.html') do
    it { should exist }
    it { should be_file }
    its('mode') { should cmp '0755' }
    its('owner') { should eq 'nginx' }
    its('group') { should eq 'nginx' }
    its('content') { should match /Please work!/ }
    its('content') { should match /This is a test/ }
    its('content') { should match /Hello, World!/ }
  end
end

control 'nginx_conf_006' do
  impact 0.8
  title 'nginx_conf'
  desc 'check the nginx configurations'
  tag 'nginx'

  describe directory('/etc/nginx') do
    it { should exist }
    it { should be_directory }
    its('mode') { should cmp '0755' }
  end

  describe directory('/var/log/nginx') do
    it { should exist }
    it { should be_directory }
    its('mode') { should cmp '0755' }
  end

  describe directory('/run') do
    it { should exist }
    it { should be_directory }
    its('mode') { should cmp '0755' }
  end

  describe file('/etc/nginx/sites-available/default') do
    it { should exist }
    it { should be_file }
    its('content') { should include 'listen 80 default_server;' }
    its('content') { should include 'root /var/www/html;' }
  end

  describe.one do
    describe file('/etc/nginx/sites-enabled/000-default') do
      it { should be_symlink }
      it { should be_linked_to '/etc/nginx/sites-available/default' }
    end

    describe file('/etc/nginx/sites-enabled/default') do
      it { should be_symlink }
      it { should be_linked_to '/etc/nginx/sites-available/default' }
    end
  end
end

control 'nginx_conf_007' do
  impact 0.8
  title 'nginx_conf'
  desc 'check nginx.conf file'
  tag 'nginx'

  describe file('/etc/nginx/nginx.conf') do
    it { should exist }
    it { should be_file }
    its('content') { should include 'worker_processes auto;' }
    its('content') { should include 'pid /run/nginx.pid;' }
    its('content') { should include 'worker_connections 768;' }
    its('content') { should include 'sendfile on;' }
    its('content') { should include 'tcp_nopush on;' }
    its('content') { should include 'tcp_nodelay on;' }
    its('content') { should include 'keepalive_timeout 65;' }
    its('content') { should include 'types_hash_max_size 2048;' }
  end
end

control 'nginx_conf_008' do
  impact 0.8
  title 'nginx_conf'
  desc 'check if in the web-browser content is reflected'
  tag 'nginx'

  describe command('curl http://localhost') do
    its('stdout') { should match /Please work!/ }
    its('stdout') { should match /This is a test/ }
    its('stdout') { should match /Hello, World!/ }
  end
end
