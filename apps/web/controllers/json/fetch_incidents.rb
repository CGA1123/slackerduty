# frozen_string_literal: true

module Web
  module Controllers
    module Json
      class FetchIncidents
        include Web::Action

        before :authenticate_user!

        def call(*)
          organisation = OrganisationRepository.new.find(current_user.organisation_id)
          operation = Slackerduty::Operations::FetchIncidents.new.call(organisation)
          headers['Content-Type'] = 'application/json'

          if operation.success?
            self.body = operation.incidents.to_json
          else
            self.body = { error: operation.error }.to_json
            self.status = 400
          end
        end
      end
    end
  end
end
