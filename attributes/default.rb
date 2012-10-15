default['mongodb']['nodename'] = 'mongodb-single'
default['mongodb']['port'] = 27017
default['mongodb']['enable_rest'] = true
default['mongodb']['enable_jsonp'] = true
default['mongodb']['enable_nojournal'] = false
default['mongodb']['enable_directoryperdb'] = true

default['mongodb']['base_dir'] = '/data/mongodb'
default['mongodb']['etc_dir'] = File.join(node['mongodb']['base_dir'], "etc")
default['mongodb']['log_dir'] = File.join(node['mongodb']['base_dir'], "log")
default['mongodb']['data_dir'] = File.join(node['mongodb']['base_dir'], "db")

