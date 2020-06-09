# frozen_string_literal: true

require 'honeykiq'

Sidekiq.configure_server do |config|
  config.redis = { url: Slackerduty::REDIS_URL }
  config.server_middleware do |chain|
    chain.add Honeykiq::ServerMiddleware
  end

  config.client_middleware do |chain|
    chain.add Honeykiq::ClientMiddleware
  end
end

Sidekiq.configure_client do |config|
  config.redis = { url: Slackerduty::REDIS_URL }

  config.client_middleware do |chain|
    chain.add Honeykiq::ClientMiddleware
  end
end
