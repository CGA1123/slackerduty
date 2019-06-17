# frozen_string_literal: true

require 'hanami/interactor'

module Slackerduty
  module Operations
    class UpdateIncidentStatus
      include Hanami::Interactor

      attr_reader :incident_repository, :status

      def initialize(status)
        @status = status
      end

      def call(organisation, user, incident)
        organisation
          .pager_duty_client
          .update_status(status, incident.id, 'incident', user.email)
      rescue Faraday::Error => e
        error e.message
      end
    end
  end
end
