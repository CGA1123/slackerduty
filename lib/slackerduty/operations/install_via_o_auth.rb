# frozen_string_literal: true

require 'hanami/interactor'

module Slackerduty
  module Operations
    class InstallViaOAuth
      include Hanami::Interactor

      expose(:user)

      def call(code)
        oauth_response = Slackerduty::SlackApi.oauth_access(
          code,
          Slackerduty::INSTALL_REDIRECT_URI
        )

        organisation = CreateOrganisation.new.call(
          slack_bot_token: oauth_response.fetch('bot').fetch('bot_access_token'),
          slack_bot_id: oauth_response.fetch('bot').fetch('bot_user_id'),
          name: oauth_response.fetch('team_name'),
          slack_id: oauth_response.fetch('team_id')
        ).organisation

        @user = CreateUserFromSlackId.new.call(
          organisation: organisation,
          slack_id: oauth_response.fetch('user_id')
        ).user
      rescue Slack::Web::Api::Errors::SlackError => e
        error e.message
      end
    end
  end
end
