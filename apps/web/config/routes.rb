# frozen_string_literal: true

# Configure your routes here
# See: http://hanamirb.org/guides/routing/overview/
#
# Example:
# get '/hello', to: ->(env) { [200, {}, ['Hello from Hanami!']] }
get '/', to: 'home#index'
get '/oauth/slack/install', to: 'home#oauth_install'
get '/oauth/slack/login', to: 'home#oauth_login'
get '/logout', to: 'home#logout'
get '/ping', to: 'json#pong'
