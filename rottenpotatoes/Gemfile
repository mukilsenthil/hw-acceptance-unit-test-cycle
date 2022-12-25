# frozen_string_literal: true

source 'https://rubygems.org'

ruby '3.1.2'
gem 'rails'

# for Heroku deployment
group :development, :test do
  gem 'byebug'
  gem 'capybara'
  gem 'database_cleaner'
  gem 'launchy'
  gem 'rspec-rails'
  gem 'rubocop', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
  gem "rubycritic", require: false
  gem 'sqlite3'
  gem 'ZenTest'
end

group :test do
  gem 'cucumber-rails', require: false
  gem 'cucumber-rails-training-wheels'
  gem 'rails-controller-testing'
  gem 'simplecov', require: false
end

group :production do
  gem 'pg'
end

# Gems used only for assets and not required
# in production environments by default.

gem 'jquery-rails'
gem 'sass-rails'
gem 'uglifier'

gem 'net-imap', require: false
gem 'net-pop', require: false
gem 'net-smtp', require: false
