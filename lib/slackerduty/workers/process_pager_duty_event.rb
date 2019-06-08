# frozen_string_literal: true

module Slackerduty
  module Workers
    class ProcessPagerDutyEvent
      include Sidekiq::Worker

      def perform(*); end
    end
  end
end
