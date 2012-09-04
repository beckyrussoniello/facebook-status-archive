source 'https://rubygems.org'

gem 'rails', '3.2.6'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

group :test, :development do
	gem 'sqlite3'
end

group :production do
	gem 'pg'
end

group :test do
	gem 'cucumber-rails', :require => false
	gem 'rspec-rails'
	gem 'capybara'
	gem 'factory_girl_rails'
	gem 'database_cleaner'
	gem 'launchy'
	gem 'simplecov', :require => false
	gem 'mogli', :require => false
	gem 'fakeweb', :require => false
	gem 'timecop'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'
gem 'koala'
gem 'httparty'
gem 'omniauth', :git => 'git://github.com/intridea/omniauth.git'
gem 'omniauth-facebook'
gem 'rtf', '~> 0.3.3'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'
