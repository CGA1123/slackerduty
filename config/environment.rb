# frozen_string_literal: true

require 'bundler/setup'
require 'hanami/model'
require 'hanami/setup'
require 'hanami/middleware/body_parser'
require 'sidekiq/web'

require_relative '../apps/web/application'
require_relative '../apps/api/application'

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

  middleware.use Hanami::Middleware::BodyParser, :json

  model do
    ##
    # Database adapter
    #
    # Available options:
    #
    #  * SQL adapter
    #    adapter :sql, 'sqlite://db/slackerduty_development.sqlite3'
    #    adapter :sql, 'postgresql://localhost/slackerduty_development'
    #    adapter :sql, 'mysql://localhost/slackerduty_development'
    #
    adapter :sql, ENV.fetch('DATABASE_URL')

    ##
    # Migrations
    #
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
