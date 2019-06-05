# frozen_string_literal: true

module Workers
  class NotifySlack
    include Sidekiq::Worker

    sidekiq_options queue: :slackerduty, retry: true, backtrace: 5

    def perform(event)
      return unless %w[
        incident.trigger
        incident.acknowledge
        incident.resolve
        incident.unacknowledge
      ].include?(event.fetch('event'))

      incident = event.fetch('incident')
      log_entries = event.fetch('log_entries')

      slackerduty_alert = Slackerduty::Alert.new(incident, log_entries)

      blocks = slackerduty_alert.as_json
      notification_text = slackerduty_alert.notification_text

      slack = Slackerduty::SlackApi.client
      messages_to_update = Models::Message.where(incident_id: incident['id']).to_a
      users_to_notify =
        Models::User
        .where(notifications_enabled: true)
        .where.not(id: messages_to_update.map(&:user_id))
        .joins(:subscriptions)
        .where("subscriptions.escalation_policy_id = '#{incident['escalation_policy']['id']}'")
        .to_a

      puts "Notifying #{users_to_notify.count} users"
      puts "Updating  #{messages_to_update.count} messages"

      users_to_notify.each do |user|
        slack_message = slack.chat_postMessage(
          channel: user.slack_id,
          blocks: blocks,
          text: notification_text,
          as_user: true
        )

        Models::Message.create!(
          user_id: user.id,
          slack_ts: slack_message['ts'],
          slack_channel: slack_message['channel'],
          incident_id: incident['id']
        )
      end

      messages_to_update.each do |message|
        slack.chat_update(
          channel: message.slack_channel,
          ts: message.slack_ts,
          blocks: blocks,
          text: notification_text
        )
      end
    end
  end
end
