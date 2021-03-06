# frozen_string_literal: true

require 'hanami/interactor'

module Slackerduty
  module Commands
    class RegisterChannel
      include Hanami::Interactor

      expose(:message)

      attr_reader :user_repository, :channel_repository

      def initialize(user_repository: UserRepository.new, channel_repository: ChannelRepository.new)
        @channel_repository = channel_repository
        @user_repository = user_repository
      end

      def call(user_id, organisation, _args, channel_id, channel_name)
        user = user_repository.from_slack_id(user_id)

        if user
          channel = find_channel(id: channel_id) || create_channel(
            id: channel_id,
            name: channel_name,
            organisation_id: organisation.id
          )

          @message = if channel
                       'Channel Set Up! Go to https://slackerduty.herokuapp.com to set up subscriptions.'
                     else
                       'Something unexpected happened when trying to register this channel :('
                     end
        else
          @message = "You're account has not been linked. `/sd link`"
        end
      end

      private

      def find_channel(id:)
        channel_repository.from_slack_id(id)
      end

      def create_channel(id:, name:, organisation_id:)
        channel_repository.create(
          id: id,
          name: name,
          organisation_id: organisation_id
        )
      end
    end
  end
end
