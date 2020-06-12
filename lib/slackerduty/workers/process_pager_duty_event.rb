# frozen_string_literal: true

module Slackerduty
  module Workers
    class ProcessPagerDutyEvent
      include Sidekiq::Worker

      def perform(params)
        params.deep_symbolize_keys!

        message = params.fetch(:message)

        Honeycomb.add_field('event_type', message.fetch(:event))

        Operations::ProcessPagerDutyEvent.new.call(
          token: params.fetch(:token),
          event: message.fetch(:event),
          incident: message.fetch(:incident),
          log_entries: message.fetch(:log_entries)
        )
      end
    end
  end
end
