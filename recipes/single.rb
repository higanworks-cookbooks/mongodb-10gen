include_recipe "mongodb-10gen::default"

mongonode = node['mongodb']


directory File.join(mongonode['data_dir'], mongonode['nodename']) do
  owner "mongodb"
  group "mongodb"
  mode 00700
end

directory File.join(mongonode['log_dir']) do
  owner "mongodb"
  group "mongodb"
  mode 00755
end

template File.join("/etc/init", "#{mongonode['nodename']}.conf") do
  source "init_mongodb.erb"
  owner "root"
  group "root"
  mode 00644
end

template File.join("/etc/logrotate.d", mongonode['nodename']) do
  source "logrotate_mongodb.erb"
  owner "root"
  group "root"
  mode 00644
end

template File.join(mongonode['etc_dir'], "#{mongonode['nodename']}.conf") do
  source "mongodb.conf.erb"
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

