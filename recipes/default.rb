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

package "mongodb-10gen" do
  action :install
end
