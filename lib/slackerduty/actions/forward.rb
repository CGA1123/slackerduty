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

          slackify = Slackerduty::PagerDuty.slackify(
            incident_id: incident_id,
            forward: false,
            from: @user
          )

          blocks = slackify[:blocks].as_json
          notification_text = slackify[:notification_text]
          incident = slackify[:incident]

          slack = Slackerduty.slack_client

          slack_message = slack.chat_postMessage(
            channel: action['selected_conversation'],
            blocks: blocks,
            text: notification_text,
            as_user: true
          )

          Models::Message.create!(
            user_id: @user.id,
            slack_ts: slack_message['ts'],
            slack_channel: slack_message['channel'],
            incident_id: incident_id
          )
        rescue Slack::Web::Api::Errors::SlackError => e
          @payload = Slack::BlockKit::Composition::Mrkdwn.new(
            text: <<~MESSAGE
              Woops, something bad happened! :face_with_head_bandage:
              ```
              Slack::Web::Api::Errors::SlackError
              message: #{e.message}
              response: #{e.response || 'nil'}
              ```
            MESSAGE
          ).as_json

          respond
        end
      end
    end
  end
end
