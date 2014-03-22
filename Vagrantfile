# -*- mode: ruby -*-
# vi: set ft=ruby :

domain = 'cloud.v.lh'

nodes = [
	{ :hostname => 'cl1', :ip => '192.168.54.100', :box => 'vagrant-centos6.5', 
            :url => 'https://dl.dropboxusercontent.com/u/15488013/vagrant-boxes/vagrant-centos6.5.box',
            :checksum => '76b0c9043d9723d68b9777f15047d432' },
	{:hostname => 'cl2', :ip => '192.168.54.101', :box => 'vagrant-centos6.5',
            :url => 'https://dl.dropboxusercontent.com/u/15488013/vagrant-boxes/vagrant-centos6.5.box',
            :checksum => '76b0c9043d9723d68b9777f15047d432' }
]

Vagrant.configure("2") do |config|
  nodes.each do |node|
    config.vm.define node[:hostname] do |node_config|
      node_config.vm.box = node[:box]
      node_config.vm.box_url = node[:url]
      node_config.vm.host_name = node[:hostname] + '.' + domain
      node_config.vm.box_download_checksum = node[:checksum]
      node_config.vm.box_download_checksum_type = 'md5'
      node_config.vm.network :private_network, ip: node[:ip]

      memory = node[:ram] ? node[:ram] : 600;
      
      node_config.vm.provider 'virtualbox' do |v|
        v.customize [
        'modifyvm', :id,
        '--name', node[:hostname],
        '--memory', memory.to_s
        ]
      end
    end
  end

  config.vm.provision 'puppet' do |puppet|
    puppet.manifests_path = 'puppet/manifests'
    puppet.manifest_file = 'site.pp'
    puppet.module_path = 'puppet/modules'
  end
end
