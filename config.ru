# frozen_string_literal: true

require './app'
require 'sidekiq/web'

Sidekiq::Web.use Rack::Auth::Basic do |username, password|
  their_username = ::Digest::SHA256.hexdigest(username)
  our_username = ::Digest::SHA256.hexdigest(Slackerduty::SIDEKIQ_USERNAME)

  their_password = ::Digest::SHA256.hexdigest(password)
  our_password = ::Digest::SHA256.hexdigest(Slackerduty::SIDEKIQ_PASSWORD)

  Rack::Utils.secure_compare(their_username, our_username) & Rack::Utils.secure_compare(their_password, our_password)
end

run Rack::URLMap.new('/' => App, '/sidekiq' => Sidekiq::Web)
