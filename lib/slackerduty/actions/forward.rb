# frozen_string_literal: true

module Slackerduty
  module Actions
    class Forward
      attr_reader :incident_repository

      def initialize(incident_repository: IncidentRepository.new)
        @incident_repository = incident_repository
      end

      def call(organisation, _user, payload)
        incident_id = payload.fetch(:action_id).split('-').last
        incident = incident_repository.find(incident_id)

        error! 'incident not found' unless incident

        alert = Slackerduty::Alert.new(incident)

        Slackerduty::Workers::SendSlackMessage.perform_async(
          incident_id: incident.id,
          channel: payload.fetch(:selected_conversation),
          ts: nil,
          blocks: alert.as_json,
          text: alert.notification_text,
          organisation_id: organisation.id
        )
      end
    end
  end
end
