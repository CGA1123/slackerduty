# frozen_string_literal: true

module Slackerduty
  class Alert
    def initialize(incident, forward: true)
      @incident = incident
      @alert = incident.alert
      @forward = forward
    end

    def to_slack
      @to_slack ||= build_blocks
    end

    def notification_text
      @notification_text ||= "#{incident.title} :pager:"
    end

    def as_json(*)
      @as_json ||= to_slack.as_json
    end

    private

    attr_reader :incident, :alert, :forward, :from

    def build_blocks
      Slack::BlockKit.blocks do |blocks|
        blocks.append(incident_block)
        blocks.append(incident_status_block) if incident_status_block.present?
        blocks.append(incident_actions_block) if incident_actions_block.present?
        blocks.append(integration_block) if integration_block.present?
        blocks.append(forwarding_action_block) if forwarding_action_block.present?
      end
    end

    def incident_block
      @incident_block ||= Blocks::Incident.new(incident)
    end

    def incident_status_block
      @incident_status_block ||= Blocks::IncidentStatus.new(incident)
    end

    def incident_actions_block
      @incident_actions_block ||= Blocks::IncidentActions.new(incident)
    end

    def integration_block
      @integration_block ||= Blocks::Integration.new(incident, alert)
    end

    def forwarding_action_block
      @forwarding_action_block ||= Blocks::ForwardingAction.new(incident, forward)
    end
  end
end
