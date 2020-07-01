# frozen_string_literal: true

require_relative './slack_verification'

module Api
  module Controllers
    module Webhooks
      class SlackEvent
        include Api::Action
        include SlackVerification

        before :verify_slack_signature

        def call(params)
          params['event']
          self.status = 202
        end
      end
    end
  end
end
