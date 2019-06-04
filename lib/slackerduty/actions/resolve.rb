# frozen_string_literal: true

require_relative '../slack_responder'

module Slackerduty
  module Actions
    class Resolve
      include SlackResponder

      def execute
        user = Models::User.find_by!(slack_id: @params['user']['id'])
        action = @params['actions'].find { |a| a['action_id'] == 'resolve' }
        incident_id = action['value']

        client = Slackerduty.pagerduty_client

        user_response, incident_response = nil

        client.in_parallel do
          user_response = client.get("/users/#{user.pagerduty_id}")
          incident_response = client.get("/incidents/#{incident_id}")
        end

        email = user_response.body['user']['email']
        incident = incident_response.body['incident']

        return if incident['status'] == 'resolved'

        Slackerduty.pagerduty_client.put(
          "/incidents/#{incident_id}",
          {
            incident: {
              status: 'resolved',
              type: incident['type']
            }
          },
          from: email
        )
      rescue Faraday::Error => e
        @payload = Slack::BlockKit::Composition::Mrkdwn.new(
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
