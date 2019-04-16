# frozen_string_literal: true

require './app'
require 'standalone_migrations'
require 'tasks/standalone_migrations'

ActiveRecord::Base.schema_format = :sql

StandaloneMigrations::Configurator.environments_config do |env|
  env.on 'production' do
    db = URI.parse(ENV.fetch('DATABASE_URL'))
    return {
      adapter: db.scheme == 'postgres' ? 'postgresql' : db.scheme,
      host: db.host,
      username: db.user,
      password: db.password,
      database: db.path[1..-1],
      encoding: 'utf8'
    }
  end

  env.on 'development' do
    db = URI.parse(ENV.fetch('DATABASE_URL'))
    return {
      adapter: db.scheme == 'postgres' ? 'postgresql' : db.scheme,
      host: db.host,
      username: db.user,
      password: db.password,
      database: db.path[1..-1],
      encoding: 'utf8'
    }
  end

  env.on 'test' do
    db = URI.parse(ENV.fetch('DATABASE_URL'))
    return {
      adapter: db.scheme == 'postgres' ? 'postgresql' : db.scheme,
      host: db.host,
      username: db.user,
      password: db.password,
      database: db.path[1..-1],
      encoding: 'utf8'
    }
  end
end

StandaloneMigrations::Tasks.load_tasks
