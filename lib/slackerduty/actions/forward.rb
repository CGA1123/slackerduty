# frozen_string_literal: true

require_relative '../slack_responder'

module Slackerduty
  module Actions
    class Forward
      include SlackResponder

      def execute
        @params['user_id'] = @params['user']['id']

        linked_user_only do
          action = @params['actions'].first
          action_id = action['action_id']
          /forward-(?<incident_id>.*)/ =~ action_id

          # TODO: Update
          # slackify = Slackerduty::PagerDuty.slackify(
          #   incident_id: incident_id,
          #   forward: false,
          #   from: @user
          # )

          # blocks = slackify[:blocks].as_json
          # notification_text = slackify[:notification_text]

          # slack = Slackerduty.slack_client

          # slack_message = slack.chat_postMessage(
          #   channel: action['selected_conversation'],
          #   blocks: blocks,
          #   text: notification_text,
          #   as_user: true
          # )

          # Models::Message.create!(
          #   user_id: @user.id,
          #   slack_ts: slack_message['ts'],
          #   slack_channel: slack_message['channel'],
          #   incident_id: incident_id
          # )
        end
      end
    end
  end
end
