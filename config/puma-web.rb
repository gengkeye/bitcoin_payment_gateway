app_root = '/home/oldseven/app/bitcoin_payment_gateway/current'
pidfile "#{app_root}/tmp/pids/puma.pid"
state_path "#{app_root}/tmp/pids/puma.state"
stdout_redirect "#{app_root}/log/puma.stdout.log", "#{app_root}/log/puma.stderr.log", true
daemonize true
port 7000
if Rails.env.production?
  workers 4
  threads 4, 10
else
  workers 2
  threads 4, 7
end
preload_app!

on_worker_boot do
  ActiveSupport.on_load(:active_record) do
    ActiveRecord::Base.establish_connection
  end
end

before_fork do
  ActiveRecord::Base.connection_pool.disconnect!

  PumaWorkerKiller.enable_rolling_restart # Default is every 6 hours
end
