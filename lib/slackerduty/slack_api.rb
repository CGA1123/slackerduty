# frozen_string_literal: true

module Slackerduty
  class SlackApi
    def self.oauth_access(code, redirect_uri)
      Slack::Web::Client.new.oauth_access(
        code: code,
        client_id: Slackerduty::SLACK_CLIENT_ID,
        client_secret: Slackerduty::SLACK_CLIENT_SECRET,
        redirect_uri: redirect_uri
      )
    end

    attr_reader :client

    def initialize(token)
      @client = Slack::Web::Client.new(token: token)
    end
  end
end
