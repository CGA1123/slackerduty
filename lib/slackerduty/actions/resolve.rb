# frozen_string_literal: true

require_relative '../slack_responder'

module Slackerduty
  module Actions
    class Resolve
      include SlackResponder

      def execute
        user = Models::User.find_by!(slack_id: @params['user']['id'])
        action = @params['actions'].find { |a| a['action_id'] == 'resolve' }
        incident_id = action['value']['incident_id']
        incident_type = action['value']['incident_type']

        Slackerduty.pagerduty_client.put(
          "/incidents/#{incident_id}",
          {
            incident: {
              status: 'resolved',
              type: incident_type
            }
          },
          from: user.email
        )
      rescue Faraday::Error => e
        error = e.response.dig(:body, 'incident', 'errors', 0)

        return if error == 'Incident Already Resolved'

        @payload = Slack::BlockKit::Composition::Mrkdwn.new(
          response_type: 'ephemeral',
          text: <<~MESSAGE
            PagerDuty is not happy :confounded:
            ```
            #{e.message}
            ```
          MESSAGE
        ).as_json

        respond
      end
    end
  end
end
