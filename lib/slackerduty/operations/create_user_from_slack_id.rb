# frozen_string_literal: true

require 'hanami/interactor'

module Slackerduty
  module Operations
    class CreateUserFromSlackId
      include Hanami::Interactor

      expose(:user)

      attr_reader :repository

      def initialize(repository: UserRepository.new)
        @repository = repository
      end

      def call(organisation:, slack_id:)
        return user(slack_id) if user(slack_id)

        user_info = slack_user_info(organisation, slack_id)

        @user = repository.create(
          organisation_id: organisation.id,
          slack_id: slack_id,
          email: user_info.fetch('profile').fetch('email')
        )
      end

      private

      def slack_user_info(organisation, slack_id)
        organisation
          .slack_client
          .users_info(user: slack_id)
          .fetch('user')
      end

      def user(slack_id)
        @user ||= repository.from_slack_id(slack_id)
      end
    end
  end
end
