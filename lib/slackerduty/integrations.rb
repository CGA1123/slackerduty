# frozen_string_literal: true

require_relative './integrations/bugsnag'
require_relative './integrations/honeycomb'

module Slackerduty
  module Integrations
    class << self
      def integrations
        [
          Bugsnag,
          Honeycomb
        ]
      end

      def match(alerts)
        integrations.find do |integration|
          alerts.find do |alert|
            alert.dig('integration', 'summary') == integration::SUMMARY_TAG
          end
        end
      end

      def to_slack(incident, alerts)
        integration = match(alerts)

        return unless integration

        integration.to_slack(incident, alerts)
      end
    end
  end
end
