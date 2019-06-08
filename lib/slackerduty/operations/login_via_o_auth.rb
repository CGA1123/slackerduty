# frozen_string_literal: true

require 'hanami/interactor'

module Slackerduty
  module Operations
    class LoginViaOAuth
      include Hanami::Interactor

      expose(:user)

      attr_reader :user_repo, :organisation_repo

      def initialize(user_repo:, organisation_repo:)
        @user_repo = user_repo
        @organisation_repo = organisation_repo
      end

      def call(code)
        oauth_response = Slackerduty::SlackApi.oauth_access(
          code,
          Slackerduty::LOGIN_REDIRECT_URI
        )

        organisation = organisation_repo.from_slack_id(oauth_response.dig('team', 'id'))
        if organisation
          @user = CreateUserFromSlackId.new.call(
            organisation: organisation,
            slack_id: oauth_response.dig('user', 'id')
          ).user
        else
          error 'organisation not registered'
        end
      rescue Slack::Web::Api::Errors::SlackError => e
        error e.message
      end
    end
  end
end
