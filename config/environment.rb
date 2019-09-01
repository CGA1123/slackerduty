# frozen_string_literal: true

require 'bundler/setup'
require 'hanami/model'
require 'hanami/setup'
require 'hanami/middleware/body_parser'

require_relative '../apps/web/application'
require_relative '../apps/api/application'

Hanami.configure do
  mount Api::Application, at: '/api'
  mount Web::Application, at: '/'

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
