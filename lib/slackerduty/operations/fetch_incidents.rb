# frozen_string_literal: true

require 'hanami/interactor'

module Slackerduty
  module Operations
    class FetchIncidents
      include Hanami::Interactor

      expose(:incidents)

      attr_reader :repository

      def initialize(repository: IncidentRepository.new)
        @repository = repository
      end

      def call(organisation)
        @incidents = repository.active(organisation).to_a
      end
    end
  end
end
