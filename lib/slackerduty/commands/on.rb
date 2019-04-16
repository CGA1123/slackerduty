# frozen_string_literal: true

require_relative '../slack_responder'

module Slackerduty
  module Commands
    class On
      include SlackResponder

      def execute
        linked_user_only do
          @user.update!(notifications_enabled: true)

          @payload = Slack::BlockKit::Composition::Mrkdwn.new(
            text: ':loud_sound:'
          ).as_json

          respond
        end
      end
    end
  end
end
