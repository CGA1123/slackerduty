# frozen_string_literal: true

module Slackerduty
  module Blocks
    class Incident
      attr_reader :incident

      EMOJI = {
        'triggered' => ':warning:',
        'acknowledged' => ':mag:',
        'resolved' => ':ok_hand:'
      }.freeze

      def initialize(incident)
        @incident = incident
      end

      def to_slack
        @to_slack ||=
          Slack::BlockKit::Layout::Section.new do |section|
            section.mrkdwn(text: section_title)
            section.mrkdwn_field(text: status_text)
            section.mrkdwn_field(text: time_text)
          end
      end

      def section_title
        "*<#{incident['html_url']}|[##{incident['incident_number']}] #{incident['title']}>*"
      end

      def status_text
        "*Status*: #{slack_emoji} #{incident['status'].capitalize}"
      end

      def time_text
        "*Time*: #{incident['created_at']}"
      end

      def as_json(*)
        to_slack.as_json
      end

      private

      def slack_emoji
        @slack_emoji ||= EMOJI.fetch(incident['status'], '')
      end
    end
  end
end
