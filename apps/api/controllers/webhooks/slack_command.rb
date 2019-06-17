# frozen_string_literal: true

require_relative './slack_verification'

module Api
  module Controllers
    module Webhooks
      class SlackCommand
        include Api::Action
        include SlackVerification

        before :verify_slack_signature

        params do
          required(:text) { str? & filled? }
          required(:user_id) { str? & filled? }
          required(:team_id) { str? & filled? }
          required(:channel_id) { str? & filled? }
          required(:text) { str? }
        end

        def call(params)
          if params.valid?
            command, *args = params[:text].split(' ')

            Slackerduty::Operations::ProcessSlackCommand.new.call(
              user_id: params[:user_id],
              organisation_id: params[:team_id],
              channel_id: params[:channel_id],
              command: command,
              args: args
            )

            self.status = 204
          else
            self.status = 422
          end
        end
      end
    end
  end
end
