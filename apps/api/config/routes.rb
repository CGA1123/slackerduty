# frozen_string_literal: true

# Configure your routes here
# See: http://hanamirb.org/guides/routing/overview/
#
# Example:
# get '/hello', to: ->(env) { [200, {}, ['Hello from Hanami!']] }
post 'pager_duty/:pager_duty_token', to: 'webhooks#pager_duty'
post 'slack/action', to: 'webhooks#slack_action'
post 'slack/command', to: 'webhooks#slack_command'
post 'slack/event', to: 'webhooks#slack_event'
