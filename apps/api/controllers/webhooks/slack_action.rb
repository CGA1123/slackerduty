# frozen_string_literal: true

require_relative './slack_verification'

module Api
  module Controllers
    module Webhooks
      class SlackAction
        include Api::Action
        include SlackVerification

        before :verify_slack_signature

        def call(*)
          self.status = 204
        end
      end
    end
  end
end
