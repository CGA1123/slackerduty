# frozen_string_literal: true

module Workers
  class NotifySlack
    include Sidekiq::Worker

    sidekiq_options queue: :slackerduty, retry: true, backtrace: 5

    def perform(incident_id)
      slackify = Slackerduty::PagerDuty.slackify(incident_id: incident_id)
      blocks = slackify[:blocks].as_json
      notification_text = slackify[:notification_text]
      incident = slackify[:incident]

      slack = Slackerduty.slack_client
      messages_to_update = Models::Message.where(incident_id: incident_id).to_a
      users_to_notify =
        Models::User
        .where(notifications_enabled: true)
        .where.not(id: messages_to_update.map(&:user_id))
        .joins(:subscriptions)
        .where("subscriptions.escalation_policy_id = '#{incident['escalation_policy']['id']}'")
        .to_a

      puts "Notifying #{users_to_notify.count} users"
      puts "Updating  #{messages_to_update.count} messages"

      new_messages = []
      updated_messages = []

      slack.in_parallel do
        users_to_notify.each do |user|
          new_messages << slack.post(
            'chat.postMessage',
            channel: user.slack_id,
            blocks: blocks,
            text: notification_text,
            as_user: true
          )
        end

        messages_to_update.each do |message|
          updated_messages << slack.post(
            'chat.update',
            channel: message.slack_channel,
            ts: message.slack_ts,
            blocks: blocks,
            text: notification_text
          )
        end
      end

      # TODO: check errors
      # persist messages!
    end
  end
end
