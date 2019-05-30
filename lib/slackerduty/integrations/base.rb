# frozen_string_literal: true

module Slackerduty
  module Integrations
    class Base
      attr_reader :alert, :incident

      def self.to_slack(incident, alerts)
        new(incident, alerts).to_slack
      end

      def initialize(incident, alerts)
        @incident = incident
        @alert = alerts.find do |alert|
          alert.dig('integration', 'summary') == self.class::SUMMARY_TAG
        end
      end
    end
  end
end
