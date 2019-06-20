# frozen_string_literal: true

require 'hanami/interactor'

module Slackerduty
  module Operations
    class FetchPagerDutyEscalationPolicies
      include Hanami::Interactor

      expose(:escalation_policies)

      def call(organisation)
        @escalation_policies =
          organisation
          .pager_duty_client
          .escalation_policies
          .body
          .fetch('escalation_policies')
          .map(&:symbolize_keys)
          .map { |policy| policy.slice(:name, :id) }
      rescue Faraday::Error => e
        error e.message
      end
    end
  end
end
