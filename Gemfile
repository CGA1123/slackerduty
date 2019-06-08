# frozen_string_literal: true

source 'https://rubygems.org'

gem 'bugsnag-api'
gem 'faraday'
gem 'faraday_middleware'
gem 'hanami', '~> 1.3'
gem 'hanami-model', '~> 1.3'
gem 'pry'
gem 'puma'
gem 'rake'
gem 'sidekiq'
gem 'slack-ruby-client'
gem 'slack_block_kit'
gem 'typhoeus'

gem 'pg'

group :development do
  # Code reloading
  # See: http://hanamirb.org/guides/projects/code-reloading
  gem 'hanami-webconsole'
  gem 'shotgun', platforms: :ruby
end

group :test, :development do
  gem 'capybara'
  gem 'dotenv', '~> 2.4'
  gem 'rspec'
  gem 'rspec_junit_formatter'
  gem 'rubocop'
  gem 'rubocop-rspec'
end

group :test do
  gem 'database_cleaner'
end
