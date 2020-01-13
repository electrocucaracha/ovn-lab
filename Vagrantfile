# -*- mode: ruby -*-
# vi: set ft=ruby :
##############################################################################
# Copyright (c) 2020
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License, Version 2.0
# which accompanies this distribution, and is available at
# http://www.apache.org/licenses/LICENSE-2.0
##############################################################################

$no_proxy = ENV['NO_PROXY'] || ENV['no_proxy'] || "127.0.0.1,localhost"
# NOTE: This range is based on vagrant-libvirt network definition CIDR 192.168.121.0/24
(1..254).each do |i|
  $no_proxy += ",192.168.121.#{i}"
end
$no_proxy += ",10.0.2.15"
$socks_proxy = ENV['socks_proxy'] || ENV['SOCKS_PROXY'] || ""

require 'yaml'
nodes = YAML.load_file(File.dirname(__FILE__) + '/etc/idf.yml')
vagrant_boxes = YAML.load_file(File.dirname(__FILE__) + '/distros_supported.yml')

# Inventory file creation
File.open("hosts.ini", "w") do |inventory_file|
  inventory_file.puts("[all:vars]\nansible_connection=ssh\nansible_ssh_user=vagrant\nansible_ssh_pass=vagrant\n\n[all]")
  nodes.each do |node|
    inventory_file.puts("#{node['name']}")
  end
  inventory_file.puts("\n[ovn-central]")
  nodes.each do |node|
    if node['roles'].include?("ovn-central")
       inventory_file.puts(node['name'])
    end
  end
  inventory_file.puts("\n[ovn-controller]")
  nodes.each do |node|
    if node['roles'].include?("ovn-controller")
       inventory_file.puts(node['name'])
    end
  end
end

Vagrant.configure("2") do |config|
  config.vm.provider :libvirt
  config.vm.provider :virtualbox

  if ENV['http_proxy'] != nil and ENV['https_proxy'] != nil
    if not Vagrant.has_plugin?('vagrant-proxyconf')
      system 'vagrant plugin install vagrant-proxyconf'
      raise 'vagrant-proxyconf was installed but it requires to execute again'
    end
    config.proxy.http     = ENV['http_proxy'] || ENV['HTTP_PROXY'] || ""
    config.proxy.https    = ENV['https_proxy'] || ENV['HTTPS_PROXY'] || ""
    config.proxy.no_proxy = $no_proxy
  end
  config.vm.provider 'libvirt' do |v|
    v.cpu_mode = 'host-passthrough'
    v.random_hostname = true
    v.management_network_address = "192.168.121.0/24"
  end

  nodes.each do |node|
    config.vm.define node['name'] do |nodeconfig|
      nodeconfig.vm.hostname = node['name']
      nodeconfig.vm.box = vagrant_boxes[node["os"]["name"]][node["os"]["release"]]["name"]
      nodeconfig.vm.box_version = vagrant_boxes[node["os"]["name"]][node["os"]["release"]]["version"]
      nodeconfig.vm.network :private_network, :ip => node['ip'], :type => :static

      [:virtualbox, :libvirt].each do |provider|
        nodeconfig.vm.provider provider do |p, override|
          p.cpus = node["cpus"]
          p.memory = node["memory"]
        end
      end
    end
  end

  config.vm.define :installer, primary: true, autostart: false do |installer|
    installer.vm.hostname = "installer"
    installer.vm.box =  vagrant_boxes["ubuntu"]["xenial"]["name"]
    installer.vm.provision 'shell', privileged: false do |sh|
      sh.inline = <<-SHELL
        cd /vagrant
        ./install.sh | tee ~/install.log
      SHELL
    end
  end
end
