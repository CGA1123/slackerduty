# frozen_string_literal: true

require_relative './slack_verification'

module Api
  module Controllers
    module Webhooks
      class SlackAction
        include Api::Action
        include SlackVerification

        before :verify_slack_signature

        def call(params)
          action_payload = JSON.parse(
            params.to_h.fetch(:payload),
            symbolize_names: true
          )

          Slackerduty::Operations::ProcessSlackAction.new.call(action_payload)

          self.status = 204
        end
      end
    end
  end
end
