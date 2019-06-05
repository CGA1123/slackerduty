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
              Slackerduty::PagerDutyApi
              .escalation_policies
              .body
              .fetch('escalation_policies')
              .index_by { |policy| policy.fetch('id') }

            subbed = subs.map do |s|
              policy = policies.fetch(s.escalation_policy_id)

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
