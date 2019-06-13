# frozen_string_literal: true

require 'hanami/interactor'

module Slackerduty
  module Operations
    class Notify
      include Hanami::Interactor

      def initialize(message_repository:, user_repository: UserRepository.new)
        @message_repository = message_repository
        @user_repository = user_repository
      end

      def call(_organisation, incident)
        alert = Slackerduty::Alert.new(incident)
        _blocks = alert.as_json
        _notification_text = alert.notification_text

        user_payloads = []
        message_payloads = []

        (user_payloads + message_payloads)
          .each(&Slackerduty::Workers::SendSlackMessage.method(:perform_async))
      end
    end
  end
end
