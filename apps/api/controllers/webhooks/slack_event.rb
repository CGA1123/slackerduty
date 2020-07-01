# frozen_string_literal: true

require_relative './slack_verification'

module Api
  module Controllers
    module Webhooks
      class SlackEvent
        include Api::Action
        include SlackVerification

        before :verify_slack_signature

        params do
          required(:challenge) { str? & filled? }
        end

        def call(params)
          if params.valid?
            self.status = 200
            self.body = { challenge: params[:challenge] }.to_json
          else
            self.status = 422
          end
        end
      end
    end
  end
end
