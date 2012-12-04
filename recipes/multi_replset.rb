include_recipe "mongodb-10gen::default"

# node.set['mongodb']['node_type'] = "single"
# node.load_attribute_by_short_filename("default","mongodb-10gen")


(1..node['mongodb']['multi_num']).each_with_index do |id, idx|
  node.set['mongodb']['multinode_id']['idx'] = [node['mongodb']['multi_prefix'], id.to_s].join

  Chef::Log.info("Mongodb node #{node['mongodb']['multinode_id']['idx']}")

  directory ::File.join(node['mongodb']['data_dir'], node['mongodb']['multinode_id']['idx']) do
    owner "mongodb"
    group "mongodb"
    mode 00700
  end

  directory ::File.join(node['mongodb']['log_dir']) do
    owner "mongodb"
    group "mongodb"
    mode 00755
  end

  template ::File.join("/etc/init", "#{node['mongodb']['multinode_id']['idx']}.conf") do
    source "init_mongodb.erb"
    owner "root"
    group "root"
    mode 00644
    variables({
      :nodename => node['mongodb']['multinode_id']['idx']
    })
  end

  template ::File.join("/etc/logrotate.d", node['mongodb']['multinode_id']['idx']) do
    source "logrotate_mongodb.erb"
    owner "root"
    group "root"
    mode 00644
    variables({
      :nodename => node['mongodb']['multinode_id']['idx']
    })
  end

  template ::File.join(node['mongodb']['etc_dir'], "#{node['mongodb']['multinode_id']['idx']}.conf") do
    source "mongodb.conf.erb"
    owner "mongodb"
    group "mongodb"
    mode 00600
    variables({
      :nodename => node['mongodb']['multinode_id']['idx'],
          :port => node['mongodb']['port_base'] + node['mongodb']['port_step'] * idx.to_i,
    })
    Chef::Log.info "service[#{node['mongodb']['multinode_id']['idx']}]"
    notifies :restart, "service[#{node['mongodb']['multinode_id']['idx']}]"
  end


  service node['mongodb']['multinode_id']['idx'] do
    case node['platform']
    when "ubuntu"
      if node['platform_version'].to_f >= 9.10
        provider Chef::Provider::Service::Upstart
      end
    end
    action [:enable, :start]
  end


end


# create config for sharding.

#shardurls = []
# (1..6).each do |idx|
#   port = node['mongodb']['baseport'] + 5000 * idx.to_i
#   shardurls.push "#{node['ipaddress']}:#{port.to_s}"
# end
# 
# template ::File.join(node['mongodb']['misc_dir'], "sharding_import.config") do
#   source "sharding_import.config.erb"
#   owner "mongodb"
#   group "mongodb"
#   mode 00644
#   variables(
#     :shardurls => shardurls
#   )
# end
