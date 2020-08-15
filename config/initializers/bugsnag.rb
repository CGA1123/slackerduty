# config/initializers/bugsnag.rb
require 'bugsnag'

Bugsnag.configure do |config|
  config.api_key = ENV['BUGSNAG_API_KEY']
end
