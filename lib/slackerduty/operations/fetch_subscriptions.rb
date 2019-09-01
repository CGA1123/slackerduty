# frozen_string_literal: true

require 'hanami/interactor'

module Slackerduty
  module Operations
    class FetchSubscriptions
      include Hanami::Interactor

      expose(:subscriptions)

      attr_reader :subscription_repository

      def initialize(subscription_repository: SubscriptionRepository.new)
        @subscription_repository = subscription_repository
      end

      def call(organisation, user)
        policies = escalation_policies(organisation)
        subscribed_ids = subscriptions(user)

        @subscriptions =
          policies
          .map { |pol| pol.merge(subscribed: subscribed_ids.include?(pol.fetch(:id))) }
      end

      private

      def subscriptions(user)
        subscription_repository
          .for_user(user)
          .to_a
          .map(&:escalation_policy_id)
          .to_set
      end

      def escalation_policies(organisation)
        organisation
          .pager_duty_client
          .escalation_policies
          .body
          .fetch('escalation_policies')
          .map(&:symbolize_keys)
          .map { |policy| policy.slice(:id, :name) }
      end
    end
  end
end
