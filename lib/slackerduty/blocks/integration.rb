# frozen_string_literal: true

require_relative './integrations/bugsnag'
require_relative './integrations/honeycomb'

module Slackerduty
  module Blocks
    class Integration
      INTEGRATIONS = {
        'Bugsnag' => Integrations::Bugsnag,
        'Honeycomb Triggers' => Integrations::Honeycomb,
        'Honeycomb SLOs' => Integrations::Honeycomb
      }.freeze

      def initialize(incident, alert)
        @integration = find_integration(incident, alert)
      end

      def present?
        !@integration.nil?
      end

      def as_json(*)
        @integration.as_json
      end

      private

      def find_integration(incident, alert)
        INTEGRATIONS
          .fetch(alert&.dig(:body, :cef_details, :client), nil)
          &.new(incident, alert)
      end
    end
  end
end
