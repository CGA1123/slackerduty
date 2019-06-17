# frozen_string_literal: true

require 'hanami/interactor'

module Slackerduty
  module Operations
    class UpdatePagerDutyToken
      include Hanami::Interactor

      attr_reader :organisation_repository

      def initialize(organisation_repository: OrganisationRepository.new)
        @organisation_repository = organisation_repository
      end

      def call(organisation:, token:)
        client = Slackerduty::PagerDutyApi.new(token)

        # make some random request to check token...
        client.escalation_policies

        organisation_repository.update(
          organisation.id,
          pager_duty_api_key: token
        )
      rescue Faraday::Error
        error! 'token not valid'
      end
    end
  end
end
