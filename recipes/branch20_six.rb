include_recipe "mongodb-10gen::branch20"


(1..6).each do |idx|

  directory File.join(node['mongodb']['data_dir'], "mongodb#{idx}") do
    owner "mongodb"
    group "mongodb"
    mode 00700
  end

  directory File.join(node['mongodb']['log_dir']) do
    owner "mongodb"
    group "mongodb"
    mode 00755
  end

  template File.join("/etc/init", "mongodb#{idx}.conf") do
    source "init_mongodb.erb"
    owner "root"
    group "root"
    mode 00644
    variables(
      :nodename => "mongodb#{idx}",
      :data_dir => node['mongodb']['data_dir'],
      :log_dir  => node['mongodb']['log_dir']
    )
  end

  template File.join("/etc/logrotate.d", "mongodb#{idx}") do
    source "logrotate_mongodb.erb"
    owner "root"
    group "root"
    mode 00644
    variables(
      :nodename => "mongodb#{idx}",
      :log_dir  => node['mongodb']['log_dir']
    )
  end

  template File.join(node['mongodb']['etc_dir'],"mongodb#{idx}.conf") do
    source "mongodb.conf.erb"
    owner "mongodb"
    group "mongodb"
    mode 00600
    variables(
                   :nodename => "mongodb#{idx}",
                   :data_dir => node['mongodb']['data_dir'],
                    :log_dir => node['mongodb']['log_dir'],
                       :port => node['mongodb']['port'] + 5000 * idx.to_i,
                :enable_rest => node['mongodb']['enable_jsonp'],
               :enable_jsonp => node['mongodb']['enable_jsonp'],
            :enable_shardsvr => true,
           :enable_configsvr => node['mongodb']['enable_configsvr'],
           :enable_nojournal => node['mongodb']['enable_nojournal'],
      :enable_directoryperdb => node['mongodb']['enable_directoryperdb']
    )
    notifies :restart, "service[mongodb#{idx}]"
  end


  service "mongodb#{idx}" do
    case node['platform']
    when "ubuntu"
      if node['platform_version'].to_f >= 9.10
        provider Chef::Provider::Service::Upstart
      end
    end
    action [:enable, :start]
  end

end
