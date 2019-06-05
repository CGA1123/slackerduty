# frozen_string_literal: true

require_relative '../slack_responder'

module Slackerduty
  module Commands
    class Unknown
      include SlackResponder

      def execute
        @payload = Slack::BlockKit::Composition::Mrkdwn.new(
          response_type: 'ephemeral',
          text: <<~MESSAGE
            I'm sorry, I didn't understand that! :parrot-sad:
            Try `/slackerduty help`
          MESSAGE
        ).as_json

        respond
      end
    end
  end
end
