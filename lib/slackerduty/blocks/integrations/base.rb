# frozen_string_literal: true

module Slackerduty
  module Integrations
    class Base
      attr_reader :log_entry, :incident

      def initialize(incident, log_entry)
        @incident = incident
        @log_entry = log_entry
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
