require 'sidekiq'
require Rails.root.join("config", 'initializers', 'redis.rb')

Sidekiq.configure_server do |config|
  #config.redis = ConnectionPool.new(size: 5, &redis_conn)
  config.redis = $redis_config
end

Sidekiq.configure_client do |config|
  #config.redis = ConnectionPool.new(size: 1, &redis_conn)
  config.redis = $redis_config
end
