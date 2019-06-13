# frozen_string_literal: true

module Slackerduty
  module Workers
    class ProcessPagerDutyEvent
      include Sidekiq::Worker

      def perform(params)
        params.deep_symbolize_keys!

        message = params.fetch(:message)

        Operations::ProcessPagerDutyEvent.new.call(
          token: params.fetch(:token),
          incident: message.fetch(:incident),
          log_entries: message.fetch(:log_entries)
        )
      end
    end
  end
end
