# frozen_string_literal: true

module Web
  module Controllers
    module Json
      class FetchSubscriptions
        include Web::Action

        before :authenticate_user!

        def call(*)
          organisation = OrganisationRepository.new.find(current_user.organisation_id)
          operation = Slackerduty::Operations::FetchSubscriptions.new.call(
            organisation,
            current_user
          )

          self.headers.merge!('Content-Type' => 'application/json')
          if operation.success?
            self.body = operation.subscriptions.to_json
          else
            self.body = { error: operation.error }.to_json
            self.status = 400
          end
        end
      end
    end
  end
end
