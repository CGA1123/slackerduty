# frozen_string_literal: true

require_relative './base'

module Slackerduty
  module Integrations
    class Bugsnag < Base
      def self.api_client
        @api_client ||= ::Bugsnag::Api::Client.new(
          auth_token: ENV.fetch('BUGSNAG_API_TOKEN')
        )
      end

      def to_slack
        details = alert.dig(:body, :cef_details)
        error_details = details.fetch(:details)
        url = details.fetch(:client_url)
        error = error_details.fetch(:class)
        trace = stack_trace(error_details)

        Slack::BlockKit::Layout::Section.new do |section|
          section.mrkdwn(
            text: <<~BUGSNAG
              ```
              #{error}:
              #{trace.join("\n")}
              ```
              <#{url}|Bugsnag link>
            BUGSNAG
          )
        end
      end

      private

      def stack_trace(details)
        details
          .fetch(:stackTrace)
          .strip
          .split("\n")
          .slice(0, 5)
          .map(&:strip)
          .reject(&:empty?)
      end
    end
  end
end
