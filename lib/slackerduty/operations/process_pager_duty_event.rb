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

      def call(token:, incident:, log_entries:)
        organisation = organisation_repository.from_pager_duty_token(token)

        error!('Organisation Not Found') unless organisation

        incident_record = incident_repository.find(incident.fetch(:id))

        @incident = if incident_record
                      incident_repository.update(incident_record.id, status: incident.fetch(:status))
                    else
                      create_incident(organisation, incident, log_entries)
                    end

        Slackerduty::Workers::Notify.perform_async(@incident.id)
      end

      private

      def create_incident(organisation, incident, log_entries)
        incident_repository.create(
          id: incident.fetch(:id),
          title: incident.fetch(:title),
          type: incident.fetch(:type),
          service_summary: incident.fetch(:service).fetch(:summary),
          acknowledgers: incident.fetch(:acknowledgements),
          resolver: resolver(log_entries),
          alert: alert(organisation, incident),
          status: incident.fetch(:status),
          organisation_id: organisation.id,
          html_url: incident.fetch(:html_url)
        )
      end

      def resolver(log_entries)
        log_entries
          .find { |entry| entry['type'] == 'resolve_log_entry' }
          .then { |entry| Hash(entry).fetch('agent', nil) }
      end

      def alert(organisation, incident)
        operation = FetchPagerDutyIncidentAlert.new.call(
          organisation,
          incident.fetch(:id)
        )

        error! operation.error unless operation.success?

        operation.alert
      end
    end
  end
end
