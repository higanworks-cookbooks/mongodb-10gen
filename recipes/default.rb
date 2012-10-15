#
# Cookbook Name:: mongodb-10gen
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe "apt"

apt_repository "mongodb-10gen" do
  uri "http://downloads-distro.mongodb.org/repo/ubuntu-upstart"
  distribution "dist"
  components ["10gen"]
  keyserver "keyserver.ubuntu.com"
  key "7F0CEB10"
end

file "/etc/default/mongodb" do
  action :create_if_missing
  owner "root"
  content "ENABLE_MONGODB=no"
end

# cookbook apt has bug ?
# apt-get update notifies does not work.
# here is work around.
if node['chef_packages']['chef']['version'] < "10"
  execute "apt-get update" do
    command "apt-get update"
    ignore_failure true
    action :run
  end
   
  file "/etc/apt/sources.list.d/mongodb-10gen.update-once.list" do
    action :create_if_missing
    notifies :run, resources(:execute => "apt-get-update"), :immediately
  end
end

package "mongodb-10gen" do
  action :install
end

directory "/data" do
  group "root"
  owner "root"
  mode 00755
end
 
remote_directory "/data/mongodb" do
  source "mongodb"
  files_group "mongodb"
  files_owner "mongodb"
  files_mode 00644
  owner "mongodb"
  group "mongodb"
  mode 00755
end

