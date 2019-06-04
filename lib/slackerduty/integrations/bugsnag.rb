# frozen_string_literal: true

require 'bugsnag/api'
require_relative './base'

module Slackerduty
  module Integrations
    class Bugsnag < Base
      SUMMARY_TAG = 'Bugsnag'

      def self.api_client
        @api_client ||= ::Bugsnag::Api::Client.new(
          auth_token: ENV.fetch('BUGSNAG_API_TOKEN')
        )
      end

      def to_slack
        url = bugsnag_error[:html_url]
        service = incident.dig('service', 'summary')
        context = bugsnag_error[:context]
        file = bugsnag_error.dig(:grouping_fields, :file)
        line_number = bugsnag_error.dig(:grouping_fields, :lineNumber)
        error_class = bugsnag_error[:error_class]
        error_message = bugsnag_error[:message].strip

        Slack::BlockKit::Layout::Section.new do |section|
          section.mrkdwn(
            text: <<~BUGSNAG
              :cloud: <#{url}|[#{service}] #{context}>
              :memo: `#{file}:#{line_number}`
              ```
              #{error_class}: #{error_message.truncate(500)}`
              ```
            BUGSNAG
          )
        end
      end

      private

      def bugsnag_error
        return @bugsnag_error if defined?(@bugsnag_error)

        regex = %r{https://app.bugsnag.com/(?<org_slug>.*)/(?<project_slug>.*)/errors/(?<error_id>[a-zA-Z0-9]+)(\?.*)?}

        url = alert['body']['details']['url']
        matches = url.match(regex)
        org = client
              .organizations
              .find { |o| o[:slug] == matches[:org_slug] }

        project = client
                  .projects(org[:id], per_page: 100)
                  .find { |p| p[:slug] == matches[:project_slug] }

        @bugsnag_error =
          client
          .error(project[:id], matches[:error_id])
          .to_h
          .merge(html_url: url)
      end

      def client
        self.class.api_client
      end
    end
  end
end
