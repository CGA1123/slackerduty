# frozen_string_literal: true

require 'umbra'

Umbra.configure do |config|
  config.redis_options = { url: ENV['REDISCLOUD_URL'] }
  config.error_handler = proc { |e| puts "error: #{e}" }
  config.request_selector = proc { |env, _resp| env['REQUEST_METHOD'] == 'GET' }
end
