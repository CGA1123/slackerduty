# frozen_string_literal: true

require_relative './pager_duty_webhook_params'

module Api
  module Controllers
    module Webhooks
      class PagerDuty
        include Api::Action
        params PagerDutyWebhookParams

        def call(params)
          if params.valid?
            process_messages(params)

            self.body = { status: :accepted }.to_json
            self.status = 202
          else
            self.body = params.errors.to_json
            self.status = 422
          end
        end

        private

        def process_messages(params)
          token = params[:pager_duty_token]

          params[:messages].each do |message|
            Slackerduty::Workers::ProcessPagerDutyEvent.perform_in(
              5,
              message: message,
              token: token
            )
          end
        end
      end
    end
  end
end
