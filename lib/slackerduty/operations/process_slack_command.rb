# frozen_string_literal: true

require 'hanami/interactor'

module Slackerduty
  module Operations
    class ProcessSlackCommand
      include Hanami::Interactor

      attr_reader :user_repository, :organisation_repository

      def initialize(
        user_repository: UserRepository.new,
        organisation_repository: OrganisationRepository.new
      )
        @user_repository = user_repository
        @organisation_repository = organisation_repository
      end

      def call(user_id:, organisation_id:, channel_id:, channel_name:, command:, args:)
        organisation = organisation_repository.from_slack_id(organisation_id)

        error! 'organisation not found' unless organisation

        result = find_command(command).call(
          user_id,
          organisation,
          args,
          channel_id,
          channel_name
        )

        message = result.success? ? result.message : result.error

        organisation.slack_client.chat_postEphemeral(
          text: message,
          channel: channel_id,
          user: user_id,
          as_user: true
        )
      end

      private

      def find_command(command)
        case command
        when 'on'
          Slackerduty::Commands::On.new
        when 'off'
          Slackerduty::Commands::Off.new
        when 'link'
          Slackerduty::Commands::Link.new
        when 'register-channel'
          Slackerduty::Commands::RegisterChannel.new
        else
          Slackerduty::Commands::Help.new
        end
      end
    end
  end
end
