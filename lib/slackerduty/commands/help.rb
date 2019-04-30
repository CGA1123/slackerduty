# frozen_string_literal: true

require_relative '../slack_responder'

module Slackerduty
  module Commands
    class Help
      include SlackResponder

      def execute
        @payload = Slack::BlockKit::Composition::Mrkdwn.new(
          text: <<~MESSAGE
            ```
            slackerduty v#{Slackerduty::VERSION}
            help                - Print this message
            link                - Link your PagerDuty account
            on                  - Start receiving notifications
            off                 - Stop receiving notifications
            sub POLICY_ID       - Subscribe to an escalation policy
            unsub POLICY_ID     - Unubscribe to an escalation policy
            subbed              - Show which policies you are subscribed to
            policies            - List escalation policies

            You can invoke slackerduty using /slackerduty or /sd
            ```
          MESSAGE
        ).as_json

        respond
      end
    end
  end
end
