# frozen_string_literal: true

require 'hanami/interactor'

module Slackerduty
  module Operations
    class Notify
      include Hanami::Interactor

      def initialize(message_repository: MessageRepository.new, user_repository: UserRepository.new)
        @message_repository = message_repository
        @user_repository = user_repository
      end

      def call(_organisation, incident)
        alert = Slackerduty::Alert.new(incident)
        blocks = alert.to_slack
        text = alert.notification_text

        user_payloads
          .merge(message_payloads)
          .map { |channel, ts| { blocks: blocks, text: text, channel: channel, ts: ts, incident_id: incident.id } }
          .each(&Slackerduty::Workers::SendSlackMessage.method(:perform_async))
      end

      def user_payloads
        user_repository
          .with_notifications_enabled
          .map { |user| { user.slack_channel => nil } }
      end

      def message_payloads(incident_id)
        message_repository
          .for_incident_id(incident_id)
          .map { |message| { message.slack_channel => message.slack_ts } }
      end
    end
  end
end
