# frozen_string_literal: true

require_relative '../slack_responder'

module Slackerduty
  module Actions
    class Unknown
      include SlackResponder

      def execute
        @payload = Slack::BlockKit::Composition::Mrkdwn.new(
          text: "An unexpected action was processed :sweat_smile:"
        ).as_json

        respond
      end
    end
  end
end
