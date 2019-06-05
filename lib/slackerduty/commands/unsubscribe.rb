# frozen_string_literal: true

require_relative '../slack_responder'

module Slackerduty
  module Commands
    class Unsubscribe
      include SlackResponder

      def execute
        linked_user_only do
          policy_id = args.first

          Models::Subscription.find_by!(
            user_id: @user.id,
            escalation_policy_id: policy_id
          ).destroy!

          @payload = Slack::BlockKit::Composition::Mrkdwn.new(
            text: <<~MESSAGE
              You unsubscribed from escalation policy with ID #{policy_id}!
              `/slackerduty subbed` to see your subscriptions.
            MESSAGE
          )

          respond
        end
      rescue ActiveRecord::RecordNotFound
        @payload = Slack::BlockKit::Composition::Mrkdwn.new(
          text: <<~MESSAGE
            You aren't subscribed to any escalation policy with that ID
            `/slackerduty subbed` to see your subscriptions.
            `/slackerduty policies` to see escalation policies.
          MESSAGE
        )

        respond
      end
    end
  end
end
