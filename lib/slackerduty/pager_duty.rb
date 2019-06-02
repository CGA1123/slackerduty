# frozen_string_literal: true

module Slackerduty
  module PagerDuty
    class << self
      def slackify(incident_id:, forward: true, from: nil)
        client = Slackerduty.pagerduty_client
        incident, alerts, log_entries = nil

        threads = []
        threads << Thread.new { incident = client.get("/incidents/#{incident_id}")['incident'] }
        threads << Thread.new { alerts = client.get("/incidents/#{incident_id}/alerts")['alerts'] }
        threads << Thread.new { log_entries = client.get("/incidents/#{incident_id}/log_entries")['log_entries'] }

        threads.map(&:join)

        acknowledgers = incident['acknowledgements'].map { |ack| ack['acknowledger'] }.uniq
        resolution_log_entry = log_entries.find { |entry| entry['type'] == 'resolve_log_entry' }
        possible_actions =
          case incident['status']
          when 'triggered'
            %w[acknowledge resolve]
          when 'acknowledged'
            %w[acknowledge resolve]
          else
            []
          end

        status_emoji =
          case incident['status']
          when 'triggered'
            ':warning:'
          when 'acknowledged'
            ':mag:'
          when 'resolved'
            ':green_check:'
          else
            ''
          end


        blocks = Slack::BlockKit.blocks do |blocks|
          blocks.section do |section|
            section.mrkdwn(text: "*<#{incident['html_url']}|[##{incident['incident_number']}] #{incident['title']}>*")
            section.mrkdwn_field(text: "*Status*: #{status_emoji}#{incident['status']}")
            section.mrkdwn_field(text: "*Urgency*: #{incident['urgency']}")
            section.mrkdwn_field(text: "*Service*: #{incident['service']['summary']}")
            section.mrkdwn_field(text: "*Time*: #{incident['created_at']}")
          end

          if !acknowledgers.empty? || resolution_log_entry
            blocks.context do |context|
              unless acknowledgers.empty?
                context.mrkdwn(
                  text: "Acks: #{acknowledgers.map { |a| agent_reference(a) }.join(', ')}"
                )
              end

              if resolution_log_entry
                context.mrkdwn(
                  text: "Resolved By: #{agent_reference(resolution_log_entry['agent'])}"
                )
              end
            end
          end

          unless possible_actions.empty?
            blocks.actions do |actions|
              possible_actions.each do |a|
                actions.button(
                  text: a.capitalize,
                  action_id: a.to_s,
                  value: incident['id']
                )
              end
            end
          end

          integration_info = Integrations.to_slack(incident, alerts)

          if integration_info
            blocks.divider
            blocks.append(integration_info)
          end

          blocks.append(forwarding_action(incident)) if forward
          blocks.append(forwarded_message(incident, from)) if from
        end

        {
          blocks: blocks,
          notification_text: "[##{incident['incident_number']}] #{status_emoji} #{incident['title']} :pager:",
          incident: incident
        }
      end

      private

      def forwarding_action(incident)
        Slack::BlockKit::Layout::Section.new do |section|
          section.mrkdwn(text: '*Forward alert to:*')
          section.conversation_select(placeholder: 'Select Conversation', action_id: "forward-#{incident['id']}") do |cs|
            cs.confirmation_dialog do |cd|
              cd.title(text: 'Are you sure?')
              cd.confirm(text: 'Forward Alert')
              cd.deny(text: 'Cancel')
              cd.plain_text(text: 'This will notify the selected conversation')
            end
          end
        end
      end

      def forwarded_message(incident, from)
        Slack::BlockKit::Layout::Context.new do |context|
          context.mrkdwn(text: "This alert was forwarded to you by <@#{from.slack_id}>")
        end
      end

      def agent_reference(agent)
        if agent['type'] == 'user_reference' || agent['type'] == 'user'
          user = Models::User.find_by(pagerduty_id: agent['id'])

          return "<@#{user.slack_id}>" if user
        end

        agent['summary']
      end
    end
  end
end
