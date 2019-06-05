# frozen_string_literal: true

require 'sidekiq'
require 'sidekiq/web'
require 'sinatra'
require 'sinatra/reloader' if development?
require 'dotenv/load' if development?
require 'slack/block_kit'
require 'slack-ruby-client'
require 'pg'
require 'active_record'

Dir[File.join(__dir__, 'lib', '*.rb')].each { |file| require file }
Dir[File.join(__dir__, 'lib', '**', '*.rb')].each { |file| require file }
Dir[File.join(__dir__, 'app', '*.rb')].each { |file| require file }
Dir[File.join(__dir__, 'app', 'actions', '*.rb')].each { |file| require file }
Dir[File.join(__dir__, 'app', 'workers', '*.rb')].each { |file| require file }
Dir[File.join(__dir__, 'app', 'models', '*.rb')].each { |file| require file }

class App < Sinatra::Base
  def self.handler(action)
    proc { action.call(self) }
  end

  get '/', &handler(Actions::Root)
  post '/pager_duty', &handler(Actions::PagerDuty)
  post '/slack/action', &handler(Actions::SlackAction)
  post '/slack/command', &handler(Actions::SlackCommand)

  run! if app_file == $PROGRAM_NAME
end
