# frozen_string_literal: true

source 'https://rubygems.org'

ruby '2.6.6'

gem 'faraday'
gem 'faraday_middleware'
gem 'hanami', '~> 1.3'
gem 'hanami-model', '~> 1.3'
gem 'pg'
gem 'pry'
gem 'puma'
gem 'rake'
gem 'sidekiq'
gem 'slack-ruby-block-kit'
gem 'slack-ruby-client'
gem 'typhoeus'
gem 'warden'

group :development do
  gem 'hanami-webconsole'
  gem 'shotgun', platforms: :ruby
end

group :test, :development do
  gem 'capybara'
  gem 'dotenv', '~> 2.7'
  gem 'rspec'
  gem 'rspec_junit_formatter'
  gem 'rubocop'
  gem 'rubocop-rspec'
end

group :test do
  gem 'database_cleaner'
end
