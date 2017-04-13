set :repo_url,        'git@119.92.199.199:oldseven/bitcoin_payment_gateway.git'
set :application,     'bitcoin_payment_gateway'

# puma
set :puma_init_active_record, true  # Change to false when not using ActiveRecord
set :puma_role, :app
set :puma_config_file, 'puma.rb'

set :nginx_sites_available_path, "/etc/nginx/sites-available"
set :nginx_sites_enabled_path, "/etc/nginx/sites-enabled"


## Linked Files & Directories (Default None):
set :linked_files, %w{config/database.yml config/environments.yml config/secrets.yml config/puma.rb}
set :linked_dirs,  %w{log tmp/pids tmp/cache tmp/sockets }

# in order to prevent bundler from overwriting the version controlled binstubs
set :bundle_binstubs, nil

after 'deploy:publishing', 'deploy:restart'
