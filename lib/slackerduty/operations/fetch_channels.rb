# frozen_string_literal: true

require 'hanami/interactor'

module Slackerduty
  module Operations
    class FetchChannels
      include Hanami::Interactor

      expose(:channels)

      attr_reader :channel_repository

      def initialize(channel_repository: ChannelRepository.new)
        @channel_repository = channel_repository
      end

      def call(organisation)
        channels = channel_repository.for_organisation(organisation).to_a
        policies = escalation_policies(organisation)

        @channels = channels.map do |channel|
          {
            id: channel.id,
            subscriptions: subscriptions(policies, channel),
            name: channel.id
          }
        end
      end

      private

      def subscriptions(policies, channel)
        policies.map do |policy|
          subs = channel.channel_subscriptions.map(&:escalation_policy_id)
          subscribed = subs.include?(policy[:id])

          {
            id: policy[:id],
            name: policy[:name],
            subscribed: subscribed
          }
        end
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
