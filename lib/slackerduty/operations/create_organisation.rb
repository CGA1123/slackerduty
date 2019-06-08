# frozen_string_literal: true

require 'hanami/interactor'

module Slackerduty
  module Operations
    class CreateOrganisation
      include Hanami::Interactor

      expose(:organisation)

      attr_reader :repository

      def initialize(repository: OrganisationRepository.new)
        @repository = repository
      end

      def call(name:, slack_id:, slack_bot_token:, slack_bot_id:)
        return organisation(slack_id) if organisation(slack_id)

        @organisation = repository.create(
          name: name,
          slack_id: slack_id,
          slack_bot_token: slack_bot_token,
          slack_bot_id: slack_bot_id
        )
      end

      def organisation(slack_id)
        @organisation ||= repository.from_slack_id(slack_id)
      end
    end
  end
end
