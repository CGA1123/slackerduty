# frozen_string_literal: true

module Slackerduty
  module Actions
    class Acknowledge
      attr_reader :incident_repository

      def initialize(incident_repository: IncidentRepository.new)
        @incident_repository = incident_repository
      end

      def call(organisation, user, payload)
        incident = incident_repository.find(payload.fetch(:value))

        error! 'incident not found' unless incident

        Slackerduty::Operations::UpdateIncidentStatus.new('acknowledged').call(
          organisation,
          user,
          incident
        )
      rescue Faraday::Error => e
        error e.message
      end
    end
  end
end
