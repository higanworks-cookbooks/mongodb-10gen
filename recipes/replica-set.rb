include_recipe "mongodb-10gen::default"

mongonode = node['mongodb']


#directory File.join(mongonode['data_dir'], mongonode['nodename']) do
#  owner "mongodb"
#  group "mongodb"
#  mode 00700
#end

directory File.join(mongonode['log_dir']) do
  owner "mongodb"
  group "mongodb"
  mode 00755
end

directory File.join(mongonode['data_dir'], mongonode['nodename']) do
  owner "mongodb"
  group "mongodb"
  mode 00700
end

template File.join("/etc/init", "#{mongonode['nodename']}.conf") do
  source "init_mongodb.erb"
  owner "root"
  group "root"
  mode 00644
end

template File.join("/etc/logrotate.d", {mongonode['nodename']) do
  source "logrotate_mongodb.erb"
  owner "root"
  group "root"
  mode 00644
end

template File.join(mongonode['etc_dir'], "#{mongonode['nodename']}.conf") do
  source "mongodb_replset.conf.erb"
  owner "mongodb"
  group "mongodb"
  mode 00600
  notifies :restart, "service[#{mongonode['nodename']}]"
end


service mongonode['nodename'] do
  case node['platform']
  when "ubuntu"
    if node['platform_version'].to_f >= 9.10
      provider Chef::Provider::Service::Upstart
    end
  end
  action [:enable, :start]
end


template File.join(node['mongodb']['misc_dir'], "repconf-#{mongonode['replSet_name']}.json" ) do
  source "replica_config.json.erb"
  owner "mongodb"
  group "mongodb"
  variables({
    :rep_config => data_bag_item("mongodb_repsets", mongonode['replSet_name'])['config']
  })
  only_if data_bag("mongodb_repsets").include?(mongonode['replSet_name'])
end    
