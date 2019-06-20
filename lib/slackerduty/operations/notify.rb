# frozen_string_literal: true

require 'hanami/interactor'

module Slackerduty
  module Operations
    class Notify
      include Hanami::Interactor

      attr_reader :message_repository, :user_repository

      def initialize(message_repository: MessageRepository.new, user_repository: UserRepository.new)
        @message_repository = message_repository
        @user_repository = user_repository
      end

      def call(organisation, incident)
        alert = Slackerduty::Alert.new(incident)

        user_payloads(organisation)
          .merge(message_payloads(incident.id))
          .map { |channel, ts| to_slack_payload(channel, ts, alert, organisation, incident) }
          .each(&Slackerduty::Workers::SendSlackMessage.method(:perform_async))
      end

      private

      def to_slack_payload(channel, timestamp, alert, organisation, incident)
        {
          organisation_id: organisation.id,
          incident_id: incident.id,
          blocks: alert.as_json,
          text: alert.notification_text,
          channel: channel,
          ts: timestamp
        }
      end

      def user_payloads(organisation, incident)
        user_repository
          .notifiable(organisation, incident)
          .to_a
          .each_with_object({}) { |user, hash| hash[user.slack_channel] = nil; }
      end

      def message_payloads(incident_id)
        message_repository
          .for_incident_id(incident_id)
          .to_a
          .each_with_object({}) { |message, hash| hash[message.slack_channel] = message.slack_ts; }
      end
    end
  end
end
