default['mongodb']['enable_shardsvr'] = false
default['mongodb']['enable_configsvr'] = false
default['mongodb']['enable_rest'] = true
default['mongodb']['enable_jsonp'] = false
default['mongodb']['enable_nojournal'] = false
default['mongodb']['enable_directoryperdb'] = true

default['mongodb']['base_dir'] = '/data/mongodb'
default['mongodb']['etc_dir'] = File.join(node['mongodb']['base_dir'], "etc")
default['mongodb']['log_dir'] = File.join(node['mongodb']['base_dir'], "log")
default['mongodb']['data_dir'] = File.join(node['mongodb']['base_dir'], "db")
default['mongodb']['misc_dir'] = File.join(node['mongodb']['base_dir'], "misc")


case node['mongodb']['node_type']
when "replset"
  default['mongodb']['replSet_name'] = "repset"
  default['mongodb']['nodename'] = "mongodb-#{node['mongodb']['replSet_name']}"
  default['mongodb']['enable_shardsvr'] = true
  default['mongodb']['enable_nojournal'] = true

when "configsvr"
  default['mongodb']['nodename'] = "mongodb_config"
  default['mongodb']['port'] = 27019
  default['mongodb']['enable_configsvr'] = true

when "router"
  default['mongodb']['nodename'] = "mongos"
  default['mongodb']['port'] = 27017
  default['mongodb']['configdb'] = "127.0.0.1:27019"

else # single server
  default['mongodb']['nodename'] = "mongodb_single"
  default['mongodb']['port'] = 27017

end

