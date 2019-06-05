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

          client = Slackerduty.pagerduty_client

          incident_response, alerts_response, log_entries_response = nil

          client.in_parallel do
            incident_response = client.get("/incidents/#{incident_id}")
            alerts_response = client.get("/incidents/#{incident_id}/alerts")
            log_entries_response = client.get("/incidents/#{incident_id}/log_entries")
          end

          incident = incident_response.body.fetch('incident')
          alerts = alerts_response.body.fetch('alerts')
          log_entries = log_entries_response.body.fetch('log_entries')

          slackerduty_alert = Slackerduty::Alert.new(
            incident,
            log_entries,
            alerts,
            forward: false,
            from: @user
          )

          blocks = slackerduty_alert.as_json
          notification_text = slackerduty_alert.notification_text

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
        end
      end
    end
  end
end
