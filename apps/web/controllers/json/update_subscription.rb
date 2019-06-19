# frozen_string_literal: true

module Web
  module Controllers
    module Json
      class UpdateSubscription
        include Web::Action
        accept :json
        before :authenticate_user!

        params do
          required(:id) { filled? & str? }
          required(:subscribe) { filled? & bool? }
        end

        def call(params)
          self.headers.merge!('Content-Type' => 'application/json')

          if params.valid?
            operation = Slackerduty::Operations::UpdateSubscription.new.call(
              user: current_user,
              escalation_policy_id: params[:id],
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
