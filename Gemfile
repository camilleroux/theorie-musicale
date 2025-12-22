source 'https://rubygems.org'

ruby '3.4.8'

gem 'rails', '~> 8.1.0'

# Pin minitest to 5.x for Rails 8.0 compatibility
gem 'minitest', '~> 5.0'

# Use Puma as the app server
gem 'puma', '>= 5.0'

# Asset pipeline (Sprockets for compatibility with legacy JS)
gem 'sprockets-rails'
gem 'dartsass-rails'

# Hotwire's SPA-like page accelerator
gem 'turbo-rails'

# Build JSON APIs with ease
gem 'jbuilder'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[windows jruby]

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

# Application-specific gems
gem 'acts_as_tree'
gem 'bootstrap', '~> 5.3.0'
gem 'friendly_id'
gem 'haml-rails'
gem 'high_voltage', '~> 5.0'
gem 'jquery-rails'
gem 'meta-tags'
gem 'newrelic_rpm'
gem 'responders'
gem 'roman-numerals'

gem 'fog-aws'
gem 'sitemap_generator'

group :development, :test do
  gem 'sqlite3', '>= 2.1'

  gem 'debug', platforms: %i[mri windows], require: 'debug/prelude'

  # Static analysis for security vulnerabilities
  gem 'brakeman', require: false
end

group :development do
  gem 'web-console'
end

group :test do
  # Use system testing
  gem 'capybara'
  gem 'selenium-webdriver'
end

group :production do
  # Heroku uses MySQL (JawsDB)
  gem 'mysql2'
end
