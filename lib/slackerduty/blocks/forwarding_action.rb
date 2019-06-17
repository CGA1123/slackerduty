# frozen_string_literal: true

module Slackerduty
  module Blocks
    class ForwardingAction
      def initialize(incident, forward)
        @incident = incident
        @forward = forward
      end

      def present?
        @forward
      end

      def to_slack
        @to_slack ||= Slack::BlockKit::Layout::Section.new do |section|
          section.mrkdwn(text: '*Forward alert to:*')
          section.accessorise(conversation_select)
        end
      end

      def as_json(*)
        to_slack.as_json
      end

      private

      def conversation_select
        conversation_select = Slack::BlockKit::Element::ConversationsSelect.new(
          placeholder: 'Select Conversation',
          action_id: "forward-#{@incident.id}"
        )

        conversation_select.confirm = confirmation_dialog

        conversation_select
      end

      def confirmation_dialog
        confirmation_dialog = Slack::BlockKit::Composition::ConfirmationDialog.new
        confirmation_dialog.title(text: 'Are you sure?')
        confirmation_dialog.confirm(text: 'Forward Alert')
        confirmation_dialog.deny(text: 'Cancel')
        confirmation_dialog.plain_text(text: 'This will notify the selected conversation')

        confirmation_dialog
      end
    end
  end
end
