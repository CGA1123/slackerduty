# frozen_string_literal: true

module Slackerduty
  class AlertStatus
    attr_reader :incident, :log_entries

    def initialize(incident, log_entries)
      @incident = incident
      @log_entries = log_entries
    end

    def present?
      acknowledged? || resolved?
    end

    def to_slack
      @to_slack ||=
        Slack::BlockKit::Layout::Context.new do |context|
          context.mrkdwn(text: text)
        end
    end

    def as_json(*)
      to_slack.as_json
    end

    private

    def text
      if resolved?
        "Resolved By: #{agent_reference(resolver).join(',')}"
      else
        "Acks: #{agent_reference(*acknowledgers).join(',')}"
      end
    end

    def agent_reference(*agents)
      agents.map do |agent|
        if agent['type'] == 'user_reference' || agent['type'] == 'user'
          user = Models::User.find_by(pagerduty_id: agent['id'])

          user ? "<@#{user.slack_id}>" : agent['summary']
        else
          agent['summary']
        end
      end
    end

    def acknowledged?
      !acknowledgers.empty?
    end

    def acknowledgers
      @acknowledgers ||= incident['acknowledgements'].map { |ack| ack['acknowledger'] }.uniq
    end

    def resolved?
      !resolver.nil?
    end

    def resolver
      return @resolver if defined?(@resolver)

      @resolver =
        log_entries
        .find { |entry| entry['type'] == 'resolve_log_entry' }
        .then { |entry| Hash(entry).fetch('agent', nil) }
    end
  end
end
