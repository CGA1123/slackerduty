# frozen_string_literal: true

module Workers
  class ProcessSlackAction
    include Sidekiq::Worker

    sidekiq_options queue: :slackerduty, retry: true, backtrace: 5

    def perform(json)
      user = Models::User.find_by!(slack_id: json['user']['id'])
      action = json['actions'].first['action_id']

      puts action

      action =
        case action
        when 'acknowledge'
          Slackerduty::Actions::Acknowledge
        when 'resolve'
          Slackerduty::Actions::Resolve
        when /forward-.*/
          Slackerduty::Actions::Forward
        else
          Slackerduty::Actions::Unknown
        end

      action.call(json)
    end
  end
end
