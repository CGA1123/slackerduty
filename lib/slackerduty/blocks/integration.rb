# frozen_string_literal: true

require_relative './integrations/bugsnag'
require_relative './integrations/honeycomb'

module Slackerduty
  module Blocks
    class Integration
      INTEGRATIONS = {
        'Bugsnag' => Integrations::Bugsnag,
        'Honeycomb Triggers' => Integrations::Honeycomb
      }.freeze

      def initialize(incident, log_entries)
        @integration =
          log_entries
          .find { |entry| entry.fetch('type') == 'trigger' }
          .then { |entry| [entry, Hash(entry).fetch('client', nil)] }
          .then { |entry, client| [entry, INTEGRATIONS.fetch(client, nil)] }
          .then { |entry, integration| integration&.new(incident, entry) }
      end

      def present?
        !@integration.nil?
      end

      def as_json(*)
        @integration.as_json
      end
    end
  end
end
