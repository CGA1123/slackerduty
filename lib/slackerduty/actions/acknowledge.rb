# frozen_string_literal: true

require_relative '../slack_responder'

module Slackerduty
  module Actions
    class Acknowledge
      include SlackResponder

      def execute
        user = Models::User.find_by!(slack_id: @params['user']['id'])
        action = @params['actions'].find { |a| a['action_id'] == 'acknowledge' }
        incident_id = action['value']

        email =
          Slackerduty
          .pagerduty_client
          .get("/users/#{user.pagerduty_id}")['user']['email']

        incident = Slackerduty.pagerduty_client.get("/incidents/#{incident_id}")['incident']

        return if incident['status'] == 'resolved'

        Slackerduty.pagerduty_client.put(
          "/incidents/#{incident_id}",
          headers: { from: email },
          body: {
            incident: {
              status: 'acknowledged',
              type: incident['type']
            }
          }
        )
      rescue PagerDuty::Connection::Error => e
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
