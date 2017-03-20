# Load the Rails application.
require_relative 'application'

# env_file = Rails.root.join("config", 'environments.yml').to_s

# if File.exists?(env_file) && (env_hash = YAML.load_file(env_file)[Rails.env]).present?
#   env_hash.each do |key, value|
#     ENV[key.to_s] = value
#   end
# end

# Initialize the Rails application.
Rails.application.initialize!