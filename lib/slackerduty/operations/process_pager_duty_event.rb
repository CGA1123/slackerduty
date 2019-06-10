# frozen_string_literal: true

require 'hanami/interactor'

module Slackerduty
  module Operations
    class ProcessPagerDutyEvent
      include Hanami::Interactor

      attr_reader :incident_repository, :organisation_repository

      def initialize(incident_repo: IncidentRepository.new, org_repo: OrganisationRepository.new)
        @incident_repository = incident_repo
        @organisation_repository = org_repo
      end

      def call(token:, **_other)
        organisation = organisation_repository.from_pager_duty_token(token)

        error!('Organisation Not Found') unless organisation

        # fetch incident, persist, enqueue notify
      end
    end
  end
end
