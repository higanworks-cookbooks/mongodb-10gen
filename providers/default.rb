require 'chef/mixin/command'
require 'chef/mixin/language'
include Chef::Mixin::Command

action :create do
  mongonode = node['mongodb']

  ## update attributes
               data_dir = @new_resource.options[:data_dir] ||= mongonode['data_dir']
                log_dir = @new_resource.options[:log_dir] ||= mongonode['log_dir']
            enable_rest = @new_resource.options[:enable_rest] ||= mongonode['enable_rest']
           enable_jsonp = @new_resource.options[:enable_jsonp] ||= mongonode['enable_jsonp']
        enable_shardsvr = @new_resource.options[:enable_shardsvr] ||= mongonode['enable_shardsvr']
       enable_nojournal = @new_resource.options[:enable_nojournal] ||= mongonode['enable_nojournal']
  enable_directoryperdb = @new_resource.options[:enable_directoryperdb] ||= mongonode['enable_directoryperdb']

  directory ::File.join(log_dir) do
    puts self.inspect
    recursive true
    owner "mongodb"
    group "mongodb"
    mode 00755
    puts self.inspect
  end

  directory [data_dir, @new_resource.instance_name].join("/") do
    owner "mongodb"
    group "mongodb"
    mode 00700
  end


  template ["/etc/init", "#{@new_resource.instance_name}.conf"].join("/") do
    cookbook "mongodb-10gen"
    source "init_mongodb.erb"
    owner "root"
    group "root"
    mode 00644
    variables(
      :nodename => @new_resource.instance_name,
      :data_dir => data_dir,
      :log_dir  => log_dir
    )
  end

  template ["/etc/logrotate.d", @new_resource.instance_name].join("/") do
    cookbook "mongodb-10gen"
    source "logrotate_mongodb.erb"
    owner "root"
    group "root"
    mode 00644
    variables(
      :nodename => @new_resource.instance_name,
      :log_dir  => log_dir
    )
  end

  template [mongonode['etc_dir'], "#{@new_resource.instance_name}.conf"].join("/") do
    cookbook "mongodb-10gen"
    source "mongodb.conf.erb"
    owner "mongodb"
    group "mongodb"
    mode 00600
  variables(
                 :nodename => @new_resource.instance_name,
                 :data_dir => data_dir,
                  :log_dir => log_dir,
                     :port => port,
              :enable_rest => enable_jsonp,
             :enable_jsonp => enable_jsonp,
          :enable_shardsvr => enable_shardsvr,
         :enable_nojournal => enable_nojournal,
    :enable_directoryperdb => enable_directoryperdb
  )
  end
end
