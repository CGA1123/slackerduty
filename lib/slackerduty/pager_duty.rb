# frozen_string_literal: true

module Slackerduty
  module PagerDuty
    class << self
      def slackify(incident_id:, forward: true, from: nil)
        client = Slackerduty.pagerduty_client
        incident_response, alerts_response, log_entries_response = nil

        client.in_parallel do
          incident_response = client.get("/incidents/#{incident_id}")
          alerts_response = client.get("/incidents/#{incident_id}/alerts")
          log_entries_response = client.get("/incidents/#{incident_id}/log_entries")
        end

        incident = incident_response.body.fetch('incident')
        alerts = alerts_response.body.fetch('alerts')
        log_entries = log_entries_response.body.fetch('log_entries')

        pagerduty_alert = Alert.new(incident)
        pagerduty_alert_status = AlertStatus.new(alerts, log_entries)
        pagerduty_alert_actions = AlertActions.new(incident)

        blocks = Slack::BlockKit.blocks do |blocks|
          blocks.append(pagerduty_alert)
          blocks.append(pagerduty_alert_status) if pagerduty_alert.present?
          blocks.append(pagerduty_alert_actions) if pagerduty_alert_actions.present?

          integration_info = Integrations.to_slack(incident, alerts)

          if integration_info
            blocks.divider
            blocks.append(integration_info)
          end

          blocks.append(forwarding_action(incident_id)) if forward
          blocks.append(forwarded_message(from)) if from
        end

        {
          blocks: blocks,
          notification_text: "[##{incident['incident_number']}] #{status_emoji(status)} #{incident['title']} :pager:",
          incident: incident
        }
      end

      private

      def forwarding_action(incident_id)
        Slack::BlockKit::Layout::Section.new do |section|
          section.mrkdwn(text: '*Forward alert to:*')
          section.conversation_select(placeholder: 'Select Conversation', action_id: "forward-#{incident_id}") do |cs|
            cs.confirmation_dialog do |cd|
              cd.title(text: 'Are you sure?')
              cd.confirm(text: 'Forward Alert')
              cd.deny(text: 'Cancel')
              cd.plain_text(text: 'This will notify the selected conversation')
            end
          end
        end
      end

      def forwarded_message(from)
        Slack::BlockKit::Layout::Context.new do |context|
          context.mrkdwn(text: "This alert was forwarded to you by <@#{from.slack_id}>")
        end
      end

      def status_emoji(status)
        case status
        when 'triggered'
          ':warning:'
        when 'acknowledged'
          ':mag:'
        when 'resolved'
          ':green_check:'
        else
          ''
        end
      end

      def possible_actions(status)
        case status
        when 'triggered'
          %w[acknowledge resolve]
        when 'acknowledged'
          %w[acknowledge resolve]
        else
          []
        end
      end
    end
  end
end
