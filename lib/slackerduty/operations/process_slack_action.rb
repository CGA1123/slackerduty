# frozen_string_literal: true

# frozen_string_literal

require 'hanami/interactor'

module Slackerduty
  module Operations
    class ProcessSlackAction
      include Hanami::Interactor

      attr_reader :user_repository, :organisation_repository, :incident_repository

      def initialize(
        user_repository: UserRepository.new,
        organisation_repository: OrganisationRepository.new,
        incident_repository: IncidentRepository.new
      )
        @user_repository = user_repository
        @organisation_repository = organisation_repository
        @incident_repository = incident_repository
      end

      def call(payload)
        user_id = payload.fetch(:user).fetch(:id)
        team_id = payload.fetch(:team).fetch(:id)
        action = payload.fetch(:actions).first

        user = user_repository.from_slack_id(user_id)
        organisation = organisation_repository.from_slack_id(team_id)

        error! 'user / org not found' unless user && organisation

        action(action.fetch(:action_id))
          .call(organisation, user, action)
      end

      def action(action_id)
        case action_id
        when 'acknowledge'
          Slackerduty::Actions::Acknowledge.new
        when 'resolve'
          Slackerduty::Actions::Resolve.new
        when /forward-.*/
          Slackerduty::Actions::Forward.new
        else
          error! 'unknown action'
        end
      end
    end
  end
end
