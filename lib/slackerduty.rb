# frozen_string_literal: true

require 'faraday'
require 'faraday_middleware'
require 'typhoeus'
require 'typhoeus/adapters/faraday'

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

  module_function

  def slack_client
    @slack_client ||= Faraday.new(
      url: 'https://slack.com/api',
      headers: { 'Content-Type' => 'application/json; charset=utf-8' }
    ) do |conn|
      conn.authorization :Bearer, SLACK_BOT_OAUTH_TOKEN
      conn.request :json
      conn.response :json
      conn.adapter :typhoeus
    end
  end

  def pagerduty_client
    @pagerduty_client ||= Faraday.new(url: 'https://api.pagerduty.com') do |conn|
      conn.token_auth PAGERDUTY_TOKEN
      conn.request :json
      conn.headers[:accept] = 'application/vnd.pagerduty+json;version=2'
      conn.response :json
      conn.adapter :typhoeus
    end
  end
end
