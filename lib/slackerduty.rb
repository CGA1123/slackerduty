# frozen_string_literal: true

require 'sidekiq'
require 'slack/block_kit'
require 'slack-ruby-client'

module Slackerduty
  VERSION = '0.2.0'
  SLACK_SIGNING_SECRET = ENV.fetch('SLACK_SIGNING_SECRET')
  SLACK_CLIENT_ID = ENV.fetch('SLACK_CLIENT_ID')
  SLACK_CLIENT_SECRET = ENV.fetch('SLACK_CLIENT_SECRET')
  INSTALL_REDIRECT_URI = ENV.fetch('INSTALL_REDIRECT_URI')
  LOGIN_REDIRECT_URI = ENV.fetch('LOGIN_REDIRECT_URI')
  SIDEKIQ_USERNAME = ENV.fetch('SIDEKIQ_USERNAME')
  SIDEKIQ_PASSWORD = ENV.fetch('SIDEKIQ_PASSWORD')
  REDIS_URL = ENV.fetch('REDIS_URL')

  Sidekiq.configure_server do |config|
    config.redis = { url:  REDIS_URL }
  end

  Sidekiq.configure_client do |config|
    config.redis = { url: REDIS_URL }
  end
end
