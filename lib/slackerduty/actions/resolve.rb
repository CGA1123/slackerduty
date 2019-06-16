# frozen_string_literal: true

module Slackerduty
  module Actions
    class Resolve
      attr_reader :incident_repository

      def initialize(incident_repository: IncidentRepository.new)
        @incident_repository = incident_repository
      end

      def call(_organisation, _user, _payload)
        puts 'resolve'
      end
    end
  end
end
