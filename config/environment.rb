# frozen_string_literal: true

require 'bundler/setup'
require 'hanami/model'
require 'hanami/setup'
require 'hanami/middleware/body_parser'
require 'sidekiq/web'
require 'honeycomb-beeline'

require_relative '../apps/web/application'
require_relative '../apps/api/application'

Honeycomb.configure do |config|
  config.write_key = ENV['HONEYCOMB_WRITEKEY']
  config.dataset = 'slackerduty'
  config.service_name = 'slackerduty'
end

Sidekiq::Web.use Rack::Auth::Basic do |username, password|
  their_username = ::Digest::SHA256.hexdigest(username)
  our_username = ::Digest::SHA256.hexdigest(Slackerduty::SIDEKIQ_USERNAME)

  their_password = ::Digest::SHA256.hexdigest(password)
  our_password = ::Digest::SHA256.hexdigest(Slackerduty::SIDEKIQ_PASSWORD)

  Rack::Utils.secure_compare(their_username, our_username) &
    Rack::Utils.secure_compare(their_password, our_password)
end

Hanami.configure do
  mount Api::Application, at: '/api'
  mount Sidekiq::Web, at: '/sidekiq'
  mount Web::Application, at: '/'

  middleware.use Honeycomb::Rack::Middleware, client: Honeycomb.client
  middleware.use Hanami::Middleware::BodyParser, :json

  model do
    adapter :sql, ENV.fetch('DATABASE_URL')
    migrations 'db/migrations'
    schema     'db/schema.sql'
  end

  environment :development do
    # See: http://hanamirb.org/guides/projects/logging
    logger level: :debug
  end

  environment :production do
    logger level: :info, formatter: :json, filter: []
  end
end
