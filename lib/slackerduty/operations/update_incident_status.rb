# frozen_string_literal: true

require 'hanami/interactor'

module Slackerduty
  module Operations
    class UpdateIncidentStatus
      include Hanami::Interactor

      attr_reader :incident_repository

      def initialize(incident_repository: IncidentRepository)
        @incident_repository = incident_repository
      end

      def call(organisation, user, incident, status)
        organisation
          .pager_duty_client
          .update_status(status, incident.id, 'incident', user.email)
      rescue Faraday::Error => e
        error e.message
      end
    end
  end
end
