# frozen_string_literal: true

require 'hanami/interactor'

module Slackerduty
  module Operations
    class UpdateChannel
      include Hanami::Interactor

      expose(:subscriptions)

      attr_reader :channel_subscription_repository

      def initialize(channel_subscription_repository: ChannelSubscriptionRepository.new)
        @channel_subscription_repository = channel_subscription_repository
      end

      def call(organisation_id:, channel_id:, escalation_policy_id:, subscribe:)
        subscription = channel_subscription_repository.find_by_escalation_policy(
          channel_id: channel_id,
          escalation_policy_id: escalation_policy_id
        )

        handle_subscription(subscription, subscribe, channel_id, escalation_policy_id)

        @subscriptions =
          channel_subscription_repository
          .for_channel(channel_id)
          .to_a
          .map(&:escalation_policy_id)
      end

      private

      def handle_subscription(subscription, subscribe, channel_id, escalation_policy_id)
        return if subscribe && subscription
        return if !subscribe && !subscription

        if subscribe
          channel_subscription_repository.create(
            channel_id: channel_id,
            escalation_policy_id: escalation_policy_id
          )
        else
          channel_subscription_repository.delete(
            [subscription.channel_id, subscription.escalation_policy_id]
          )
        end
      end
    end
  end
end
