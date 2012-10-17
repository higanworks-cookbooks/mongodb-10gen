default['mongodb']['nodename'] = "mongodb-single"
default['mongodb']['port'] = 27017
default['mongodb']['enable_rest'] = true
default['mongodb']['enable_jsonp'] = false
default['mongodb']['enable_nojournal'] = false
default['mongodb']['enable_shardsvr'] = false
default['mongodb']['enable_directoryperdb'] = true

default['mongodb']['base_dir'] = '/data/mongodb'
default['mongodb']['etc_dir'] = File.join(node['mongodb']['base_dir'], "etc")
default['mongodb']['log_dir'] = File.join(node['mongodb']['base_dir'], "log")
default['mongodb']['data_dir'] = File.join(node['mongodb']['base_dir'], "db")
default['mongodb']['misc_dir'] = File.join(node['mongodb']['base_dir'], "misc")

if node['mongodb']['replset'] then
  default['mongodb']['replSet_name'] = "repset"
  default['mongodb']['nodename'] = "mongodb-#{node['mongodb']['replSet_name']}"
  default['mongodb']['enable_shardsvr'] = true
  default['mongodb']['enable_nojournal'] = true
end
