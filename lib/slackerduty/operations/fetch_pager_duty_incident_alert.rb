# frozen_string_literal: true

require 'hanami/interactor'

module Slackerduty
  module Operations
    class FetchPagerDutyIncidentAlert
      include Hanami::Interactor

      expose(:alert)

      def call(organisation, incident_id)
        @alert =
          organisation
          .pager_duty_client
          .alerts(incident_id)
          .body
          .fetch('alerts')
          .map(&:deep_symbolize_keys)
          .first { |alert| !alert.fetch(:suppresed) }
          &.slice(:body, :id, :summary)
      rescue Faraday::Error => e
        error e.message
      end
    end
  end
end
