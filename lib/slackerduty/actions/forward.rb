# frozen_string_literal: true

require_relative '../slack_responder'

module Slackerduty
  module Actions
    class Forward
      include SlackResponder

      def execute
        @params['user_id'] = @params.dig('user', 'id')

        linked_user_only do
          action = @params.fetch('actions').first
          action_id = action.fetch('action_id')
          message = @params.fetch('message')
          /forward-(?<incident_id>.*)/ =~ action_id

          slack = Slackerduty::SlackApi.client

          slack_message = slack.chat_postMessage(
            channel: action.fetch('selected_conversation'),
            blocks: message.fetch('blocks'),
            text: message.fetch('text')
          )

          Models::Message.create!(
            user_id: @user.id,
            slack_ts: slack_message['ts'],
            slack_channel: slack_message['channel'],
            incident_id: incident_id
          )
        end
      end
    end
  end
end
