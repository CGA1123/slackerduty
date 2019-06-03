# frozen_string_literal: true

module Slackerduty
  VERSION = '0.1.0'
  SLACK_BOT_OAUTH_TOKEN = ENV.fetch('SLACK_BOT_OAUTH_TOKEN')
  SLACK_SIGNING_SECRET = ENV.fetch('SLACK_SIGNING_SECRET')
  PAGERDUTY_USER = ENV.fetch('PAGERDUTY_USER')
  PAGERDUTY_PASS = ENV.fetch('PAGERDUTY_PASS')
  DATABASE_URL = ENV.fetch('DATABASE_URL')
  PAGERDUTY_TOKEN = ENV.fetch('PAGERDUTY_TOKEN')
  SIDEKIQ_USERNAME = ENV.fetch('SIDEKIQ_USERNAME')
  SIDEKIQ_PASSWORD = ENV.fetch('SIDEKIQ_PASSWORD')
  REDIS_URL = ENV.fetch('REDIS_URL')

  ActiveRecord::Base.establish_connection(DATABASE_URL)

  Sidekiq.configure_server do |config|
    config.redis = { url:  REDIS_URL }
  end

  Sidekiq.configure_client do |config|
    config.redis = { url: REDIS_URL }
  end

  Slack.configure do |config|
    config.token = SLACK_BOT_OAUTH_TOKEN
  end

  Slack::Web::Client.configure do |config|
    config.user_agent = "slackerduty/#{VERSION}"
  end

  module_function

  def slack_client
    @slack_client ||= ::Slack::Web::Client.new
  end

  def pagerduty_client
    @pagerduty_client ||= ::PagerDuty::Connection.new(PAGERDUTY_TOKEN)
  end
end
