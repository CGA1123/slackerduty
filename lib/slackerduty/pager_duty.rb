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
            section.mrkdwn(
              text: "*<#{incident['html_url']}|[##{incident['incident_number']}] #{incident['title']}>*"
            )

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

          if (bs = bugsnag(alerts)) || (hc = honeycomb(alerts))
            blocks.divider
            if bs
              blocks.section do |section|
                section.mrkdwn(
                  text: <<~BUGSNAG
                    :cloud: <#{bs[:html_url]}|[#{incident['service']['summary']}] #{bs[:context]}>
                    :memo: `#{bs[:grouping_fields][:file]}:#{bs[:grouping_fields][:lineNumber]}`
                    ```
                    #{bs[:error_class]}: #{bs[:message].strip}`
                    ```
                  BUGSNAG
                )
              end
            end

            if hc
              blocks.section do |section|
                section.mrkdwn(
                  text: <<~HONEYCOMB
                    ```
                    #{hc[:trigger_description]}
                    #{hc[:description]}
                    ```
                    <#{hc[:html_url]}|Honeycomb Graph>
                  HONEYCOMB
                )
              end
            end
          end

          if forward
            blocks.section do |section|
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

          if from
            blocks.context do |context|
              context.mrkdwn(text: "This alert was forwarded to you by <@#{from.slack_id}>")
            end
          end
        end

        {
          blocks: blocks,
          notification_text: "[##{incident['incident_number']}] #{status_emoji} #{incident['title']} :pager:",
          incident: incident
        }
      end

      private

      def agent_reference(agent)
        if agent['type'] == 'user_reference' || agent['type'] == 'user'
          user = Models::User.find_by(pagerduty_id: agent['id'])

          return "<@#{user.slack_id}>" if user
        end

        agent['summary']
      end

      def bugsnag(alerts)
        alert = alerts.find { |a| a['integration'] && a['integration']['summary'] == 'Bugsnag' }

        return unless alert

        regex = %r{https://app.bugsnag.com/(?<org_slug>.*)/(?<project_slug>.*)/errors/(?<error_id>[a-zA-Z0-9]+)(\?.*)?}

        matches = alert['body']['details']['url'].match(regex)
        client = Slackerduty.bugsnag_client
        org = client.organizations.find { |o| o[:slug] == matches[:org_slug] }
        project = client.projects(org[:id], per_page: 100).find { |p| p[:slug] == matches[:project_slug] }

        client
          .error(project[:id], matches[:error_id])
          .to_h
          .merge(html_url: alert['body']['details']['url'].split('?').first)
      end

      def honeycomb(alerts)
        alert = alerts.find { |a| a['integration'] && a['integration']['summary'] == 'Honeycomb' }

        return unless alert

        {
          html_url: alert['body']['contexts'].first['href'],
          trigger_description: alert.dig('body', 'details', 'trigger_description'),
          description: alert.dig('body', 'details', 'description')
        }
      end
    end
  end
end
