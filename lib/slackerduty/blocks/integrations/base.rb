# frozen_string_literal: true

module Slackerduty
  module Integrations
    class Base
      attr_reader :alert, :incident

      def initialize(incident, alert)
        @incident = incident
        @alert = alert
      end

      def to_slack
        raise 'Not Implemented'
      end

      def as_json(*)
        to_slack.as_json
      end
    end
  end
end
