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


## default ports, override it.
default['mongodb']['baseport']   = 27017
default['mongodb']['routerport'] = 27018
default['mongodb']['configport'] = 27019


## define defaut nodename.
# This rule doesn't work well when server has more than one types.
# To workaround, use load_attribute_by_short_filename method in your recipe.
case node['mongodb']['node_type']
when "replset"
  default['mongodb']['replSet_name'] = "repset"
  default['mongodb']['nodename'] = "mongodb-#{node['mongodb']['replSet_name']}"
  default['mongodb']['enable_shardsvr'] = true
  default['mongodb']['enable_nojournal'] = true

when "configsvr"
  default['mongodb']['nodename'] = "mongodb_config"
  default['mongodb']['enable_configsvr'] = true

when "router"
  default['mongodb']['nodename'] = "mongos"
  default['mongodb']['configdb'] = "127.0.0.1:27019"

else # single server
  default['mongodb']['nodename'] = "mongodb_single"
end

