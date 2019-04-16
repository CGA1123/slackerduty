# frozen_string_literal: true

require_relative '../slack_responder'

module Slackerduty
  module Commands
    class Off
      include SlackResponder

      def execute
        linked_user_only do
          @user.update!(notifications_enabled: false)

          @payload = Slack::BlockKit::Composition::Mrkdwn.new(
            text: ':mute:'
          ).as_json

          respond
        end
      end
    end
  end
end
