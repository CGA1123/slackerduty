# frozen_string_literal: true

require_relative '../slack_responder'

module Slackerduty
  module Commands
    class Subscriptions
      include SlackResponder

      def execute
        linked_user_only do
          subs = Models::Subscription.where(user_id: @user.id).to_a
          if subs.count.positive?
            policies =
              Slackerduty
              .pagerduty_client
              .get('/escalation_policies')
              .body['escalation_policies']

            subbed = subs.map do |s|
              policy = policies.find { |p| p['id'] == s.escalation_policy_id }

              "#{policy['id']}\t#{policy['name']}" if policy
            end.compact.join("\n")

            text = <<~MESSAGE
              ```
              ID     \tNAME
              #{subbed}
              ```
               `/slackerduty policies` to view all policies.
              `/slackerduty sub ID` to subscribe to a policy.
            MESSAGE
          else
            text = <<~MESSAGE
              You haven't subscribed to any escalation policies.
              `/slackerduty policies` to view all policies.
              `/slackerduty sub ID` to subscribe to a policy.
            MESSAGE
          end

          @payload = Slack::BlockKit::Composition::Mrkdwn.new(text: text)

          respond
        end
      end
    end
  end
end
