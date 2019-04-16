# frozen_string_literal: true

require_relative '../slack_responder'

module Slackerduty
  module Commands
    class Wip
      include SlackResponder

      def execute
        @payload = Slack::BlockKit::Composition::Mrkdwn.new(
          text: "Sorry, this command is still a wip :building_construction:"
        ).as_json

        respond
      end
    end
  end
end
