# frozen_string_literal: true

module Slackerduty
  module Blocks
    class ForwardedBy
      def initialize(from)
        @from = from
      end

      def present?
        !@from.nil?
      end

      def to_slack
        @to_slack ||= Slack::BlockKit::Layout::Context.new do |context|
          context.mrkdwn(text: "This alert was forwarded to you by <@#{@from.slack_id}>")
        end
      end

      def as_json(*)
        to_slack.as_json
      end
    end
  end
end
