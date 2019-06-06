# frozen_string_literal: true

module Slackerduty
  class Alert
    def initialize(incident, log_entries, alerts, forward: true)
      @incident = incident
      @log_entries = log_entries
      @alerts = alerts
      @forward = forward
    end

    def to_slack
      @to_slack ||= build_blocks
    end

    def notification_text
      "[##{incident['incident_number']}] #{incident['title']} :pager:"
    end

    def as_json(*)
      to_slack.as_json
    end

    private

    attr_reader :incident, :log_entries, :alerts, :forward, :from

    def build_blocks
      incident_block = Blocks::Incident.new(incident)
      incident_status_block = Blocks::IncidentStatus.new(incident, log_entries)
      incident_actions_block = Blocks::IncidentActions.new(incident)
      integration_block = Blocks::Integration.new(incident, alerts)
      forwarding_action_block = Blocks::ForwardingAction.new(incident, forward)

      Slack::BlockKit.blocks do |blocks|
        blocks.append(incident_block)
        blocks.append(incident_status_block) if incident_status_block.present?
        blocks.append(incident_actions_block) if incident_actions_block.present?

        if integration_block.present?
          blocks.divider
          blocks.append(integration_block)
        end

        blocks.append(forwarding_action_block) if forwarding_action_block.present?
        blocks.append(forwarded_by_block) if forwarded_by_block.present?
      end
    end
  end
end
