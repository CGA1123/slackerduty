# frozen_string_literal: true

require_relative './integrations/bugsnag'
require_relative './integrations/honeycomb'

module Slackerduty
  module Blocks
    class Integration
      INTEGRATIONS = {
        'Bugsnag' => Integrations::Bugsnag,
        'Honeycomb' => Integrations::Honeycomb
      }.freeze

      def initialize(incident, alerts)
        @integration = find_integration(incident, alerts)
      end

      def present?
        !@integration.nil?
      end

      def as_json(*)
        @integration.as_json
      end

      private

      def find_integration(incident, alerts)
        keys = INTEGRATIONS.keys

        alert = alerts.find { |a| keys.include?(a.dig('integration', 'summary')) }
        integration_klass = INTEGRATIONS[alert.dig('integration', 'summary')]

        integration_klass&.new(incident, alert)
      end
    end
  end
end
