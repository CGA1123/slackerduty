# frozen_string_literal: true

module Web
  module Controllers
    module Json
      class UpdateChannels
        include Web::Action

        params do
          required(:id) { filled? & str? }
          required(:subscription_id) { filled? & str? }
          required(:subscribe) { filled? & bool? }
        end

        before :authenticate_user!

        def call(params)
          headers['Content-Type'] = 'application/json'

          if params.valid?
            operation = Slackerduty::Operations::UpdateChannel.new.call(
              channel_id: params[:id],
              escalation_policy_id: params[:subscription_id],
              subscribe: params[:subscribe]
            )

            self.body = operation.subscriptions.to_json
            self.status = 200
          else
            self.status = 400
            self.body = params.error.to_json
          end
        end
      end
    end
  end
end
