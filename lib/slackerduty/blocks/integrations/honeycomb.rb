# frozen_string_literal: true

require_relative './base'

module Slackerduty
  module Integrations
    class Honeycomb < Base
      def to_slack
        details = log_entry.fetch('details')
        trigger_description = details.fetch('trigger_description')
        description = details.fetch('description')
        url = log_entry.fetch('client_url')

        Slack::BlockKit::Layout::Section.new do |section|
          section.mrkdwn(
            text: <<~HONEYCOMB
              ```
              #{trigger_description}
              ```
              ```
              #{description}
              ```
              <#{url}|Honeycomb Graph>
            HONEYCOMB
          )
        end
      end
    end
  end
end
