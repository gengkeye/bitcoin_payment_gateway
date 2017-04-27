set :repo_url,        'git@119.92.199.199:oldseven/bitcoin_payment_gateway.git'
set :application,     'bitcoin_payment_gateway'

set :pty,             true
set :use_sudo,        false
set :stage,           :production
set :deploy_via,      :remote_cache

# puma
set :puma_threads,    [4, 16]
set :puma_workers,    0
set :puma_init_active_record, true  # Change to false when not using ActiveRecord
set :puma_role, :app
set :puma_config_file, 'puma.rb'

set :nginx_sites_available_path, "/etc/nginx/sites-available"
set :nginx_sites_enabled_path, "/etc/nginx/sites-enabled"


## Linked Files & Directories (Default None):
set :linked_files, %w{config/database.yml config/environments.yml config/secrets.yml puma.rb}
set :linked_dirs,  %w{log tmp/pids tmp/cache tmp/sockets }

# in order to prevent bundler from overwriting the version controlled binstubs
set :bundle_binstubs, nil

namespace :deploy do
  desc "Make sure local git is in sync with remote."
  task :check_revision do
    on roles(:app) do
      unless `git rev-parse HEAD` == `git rev-parse origin/master`
        puts "WARNING: HEAD is not the same as origin/master"
        puts "Run `git push` to sync changes."
        exit
      end
    end
  end

  desc 'Initial Deploy'
  task :initial do
    on roles(:app) do
      # before 'deploy:restart', 'puma:start'
      invoke 'deploy'
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      invoke 'puma:restart'
    end
  end

  before :starting,     :check_revision
  after  :finishing,    :compile_assets
  after  :finishing,    :cleanup
  after  :finishing,    :restart
end

after 'deploy:publishing', 'deploy:restart'
