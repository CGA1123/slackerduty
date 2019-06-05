# frozen_string_literal: true

require_relative '../slack_responder'

module Slackerduty
  module Actions
    class Acknowledge
      include SlackResponder

      def execute
        user = Models::User.find_by!(slack_id: @params['user']['id'])
        action = @params['actions'].find { |a| a['action_id'] == 'acknowledge' }
        incident_id, incident_type = action['value'].split('--')

        Slackerduty::PagerDutyApi.acknowledge(incident_id, incident_type, user.email)
      rescue Faraday::Error => e
        error = e.response.dig(:body, 'incident', 'errors', 0)

        return if error == 'Incident Already Resolved'

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
