# frozen_string_literal: true

require_relative '../slack_responder'

module Slackerduty
  module Commands
    class Ping
      include SlackResponder

      MESSAGES = [
        ':table_tennis_paddle_and_ball:',
        'PagerDuty → Slack :pager:',
        "slackerduty v#{Slackerduty::VERSION} is up and running.",
        'pong',
        "I'm here"
      ].freeze

      def execute
        @payload = Slack::BlockKit::Composition::Mrkdwn.new(
          text: MESSAGES.sample
        ).as_json

        respond
      end
    end
  end
end
