actions :create
default_action :create

attribute :instance_name, :name_attribute => true
attribute :created, :default => false

## require recipe "mongodb-10gen"

# attribute :nodename, :name_attribute => true
attribute :options, :kind_of => Hash, :default => {}
# attribute :data_dir, :default => node['mongodb']['data_dir']
# attribute :log_dir, :default => node['mongodb']['log_dir']
# attribute :port, :default => node['mongodb']['port']
# attribute :enable_rest, :default => node['mongodb']['enable_jsonp']
# attribute :enable_jsonp, :default => node['mongodb']['enable_jsonp']
# attribute :enable_shardsvr, :default => node['mongodb']['enable_shardsvr']
# attribute :enable_nojournal, :default => node['mongodb']['enable_nojournal']
# attribute :enable_directoryperdb, :default => node['mongodb']['enable_directoryperdb']
