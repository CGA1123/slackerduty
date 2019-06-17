# frozen_string_literal: true

require_relative './base'

module Slackerduty
  module Integrations
    class Honeycomb < Base
      def to_slack
        Slack::BlockKit::Layout::Section.new do |section|
          section.mrkdwn(
            text: <<~HONEYCOMB
              ```
              #{alert.dig(:body, :details, :trigger_description)}
              #{alert.dig(:body, :details, :description)}
              ```
              <#{alert.dig(:body, :contexts, 0, :href)}|Honeycomb Graph>
            HONEYCOMB
          )
        end
      end
    end
  end
end
