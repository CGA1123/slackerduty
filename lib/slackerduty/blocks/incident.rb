# frozen_string_literal: true

module Slackerduty
  module Blocks
    class Incident
      attr_reader :incident

      def initialize(incident)
        @incident = incident
      end

      def to_slack
        @to_slack ||=
          Slack::BlockKit::Layout::Section.new do |section|
            section.mrkdwn(text: "*<#{incident['html_url']}|[##{incident['incident_number']}] #{incident['title']}>*")
            section.mrkdwn_field(text: "*Status*: #{slack_emoji} #{incident['status'].capitalize}")
            section.mrkdwn_field(text: "*Time*: #{incident['created_at']}")
          end
      end

      def as_json(*)
        to_slack.as_json
      end

      private

      def slack_emoji
        @slack_emoji ||=
          case incident['status']
          when 'triggered'
            ':warning:'
          when 'acknowledged'
            ':mag:'
          when 'resolved'
            ':ok_hand:'
          else
            ''
          end
      end
    end
  end
end
