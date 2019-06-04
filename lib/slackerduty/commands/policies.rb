# frozen_string_literal: true

require_relative '../slack_responder'

module Slackerduty
  module Commands
    class Policies
      include SlackResponder

      def execute
        linked_user_only do
          policies =
            Slackerduty
            .pagerduty_client
            .get('/escalation_policies')
            .body['escalation_policies']

          text = policies.map { |p| "#{p['id']}\t#{p['name']}" }.join("\n")

          @payload = Slack::BlockKit::Composition::Mrkdwn.new(
            text: <<~MESSAGE
              ```
              ID     \tNAME
              #{text}
              ```
            MESSAGE
          )

          respond
        end
      end
    end
  end
end
