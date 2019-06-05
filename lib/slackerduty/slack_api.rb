# frozen_string_literal: true

module Slackerduty
  module SlackApi
    module_function

    def client
      @client ||= Slack::Web::Client.new(
        token: Slackerduty::SLACK_BOT_OAUTH_TOKEN
      )
    end
  end
end
