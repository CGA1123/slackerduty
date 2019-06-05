# frozen_string_literal: true

require 'bugsnag/api'
require_relative './base'

module Slackerduty
  module Integrations
    class Bugsnag < Base
      def to_slack
        description = log_entry.fetch('description')
        details = log_entry.fetch('details')
        url = details.fetch('url')
        error_class = details.fetch('class')
        stack_trace =
          details
          .fetch('stackTrace')
          .split("\n")
          .first
          .strip

        Slack::BlockKit::Layout::Section.new do |section|
          section.mrkdwn(
            text: <<~BUGSNAG
              :cloud: <#{url}|#{description}>
              :interrobang: `#{error_class}`
              :memo: `#{stack_trace}`
            BUGSNAG
          )
        end
      end
    end
  end
end
