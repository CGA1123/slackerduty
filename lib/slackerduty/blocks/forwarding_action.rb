# frozen_string_literal: true

module Slackerduty
  module Blocks
    class ForwardingAction
      def initialize(incident)
        @incident = incident
      end

      def to_slack
        @to_slack ||= Slack::BlockKit::Layout::Section.new do |section|
          section.mrkdwn(text: '*Forward alert to:*')
          section.conversation_select(
            placeholder: 'Select Conversation',
            action_id: "forward-#{@incident['id']}"
          ) do |cs|
            cs.confirmation_dialog do |cd|
              cd.title(text: 'Are you sure?')
              cd.confirm(text: 'Forward Alert')
              cd.deny(text: 'Cancel')
              cd.plain_text(text: 'This will notify the selected conversation')
            end
          end
        end
      end

      def as_json(*)
        to_slack.as_json
      end
    end
  end
end
