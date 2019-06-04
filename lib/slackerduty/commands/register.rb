# frozen_string_literal: true

require_relative '../slack_responder'

module Slackerduty
  module Commands
    class Register
      include SlackResponder

      def execute
        slack_user =
          Slackerduty
          .slack_client
          .users_info(user: @params['user_id'])['user']

        if slack_user['profile']['email']
          pagerduty_user =
            Slackerduty
            .pagerduty_client
            .get('/users', query_params: { query: slack_user['profile']['email'] })
            .body['users']
            .first

          if pagerduty_user
            user = Models::User.find_or_initialize_by(slack_id: slack_user['id'])
            user.pagerduty_id = pagerduty_user['id']

            @payload = if user.save
                         Slack::BlockKit::Composition::Mrkdwn.new(
                           text: <<~MESSAGE
                             PagerDuty account linked.
                             `/slackerduty on` to start receiving notifications.
                           MESSAGE
                         ).as_json
                       else
                         Slack::BlockKit::Composition::Mrkdwn.new(
                           text: <<~MESSAGE
                             Registration Unsuccessful!
                             Something bad happened during user saving.
                           MESSAGE
                         ).as_json
                       end
          else
            @payload = Slack::BlockKit::Composition::Mrkdwn.new(
              text: <<~MESSAGE
                Registration Unuccessfull!
                Couldn't find a PagerDuty account with your email.
              MESSAGE
            ).as_json
          end
        else
          @payload = Slack::BlockKit::Composition::Mrkdwn.new(
            text: <<~MESSAGE
              Registration Unsuccessful!
              You must have your email set in your slack profile.
            MESSAGE
          ).as_json
        end

        respond
      end
    end
  end
end
