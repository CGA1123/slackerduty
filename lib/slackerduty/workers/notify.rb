# frozen_string_literal: true

module Slackerduty
  module Workers
    class Notify
      include Sidekiq::Worker

      def perform(incident_id)
        incident = IncidentRepository.new.find(incident_id)
        organisation = OrganisationRepository.new.find(incident.organisation_id)

        raise 'incident does not exist' unless incident

        Slackerduty::Operations::Notify.new.call(
          organisation,
          incident
        )
      end
    end
  end
end
