# frozen_string_literal: true

require 'hanami/interactor'

module Slackerduty
  module Operations
    class UpdateSubscription
      include Hanami::Interactor

      expose(:subscriptions)

      attr_reader :subscriptions_repository

      def initialize(subscriptions_repository: SubscriptionsRepository.new)
        @subscriptions_repository = subscriptions_repository
      end

      def call(user:, escalation_policy_id:, subscribe:)
        subscription = subscriptions_repository.find_by_escalation_policy(
          user,
          escalation_policy_id
        )

        handle_subscription(subscribe, user, subscription)

        @subscriptions =
          subscriptions_repository
          .for_user(user)
          .to_a
          .map(&:escalation_policy_id)
      end

      private

      def handle_subscription(subscribe, user, subscription)
        return if subscribe && subscription
        return if !subscribe && !subscription

        if subscribe
          subscriptions_repository.create(
            user_id: user.id,
            escalation_policy_id: escalation_policy_id
          )
        else
          subscriptions_repository.delete(
            [subscription.user_id, subscription.escalation_policy_id]
          )
        end
      end
    end
  end
end
