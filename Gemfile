source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
# gem 'rails', '5.0.0.1'
gem 'rails', '~> 5.0.2'

# Use sqlite3 as the database for Active Record
# payment gateway server
# gem 'straight-server', git: 'git@git.nn.com:oldseven/straight-server.git', branch: :master

gem 'mysql2'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtime
gem 'execjs'
gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

gem 'straight-server-kit'

gem 'x-signature'

gem 'bootstrap-sass', '~> 3.3.6'

gem 'redis', '~> 3.3.1'

# Map Redis types directly to Ruby objects. Works with any class or ORM.
gem 'redis-objects', '~> 1.2.1'

# Simple, efficient background processing for Ruby.https://github.com/mperham/sidekiq
gem 'sidekiq'

gem 'thin'

gem 'httparty'
gem 'excon'
gem "typhoeus"
gem 'syslogger'
gem "cpowell-SyslogLogger"
gem 'rqrcode'
gem 'rqrcode_png'
gem 'btcruby', '~>1.6'

gem 'web-console', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  gem 'pry-rails'

  # Access an IRB console on exception pages or by using <%= console %> in views

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'capistrano'
  gem 'capistrano-rvm'
  gem 'capistrano-rails'
  gem 'capistrano-bundler'
  gem 'capistrano3-puma'
  gem 'capistrano-sidekiq'
end

group :production do
  gem 'puma', platform: :ruby
  gem 'exception_notification'
end
