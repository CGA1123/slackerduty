# frozen_string_literal: true

module Web
  module Controllers
    module Organisations
      class Update
        include Web::Action

        before :authenticate_user!

        params do
          required(:organisation).schema do
            required(:pager_duty_api_key) { filled? & str? }
          end
        end

        def call(params)
          organisation = OrganisationRepository.new.find(current_user.organisation_id)

          if params.valid?
            Slackerduty::Operations::UpdatePagerDutyToken.new.call(
              organisation: organisation,
              token: params[:organisation][:pager_duty_api_key]
            )
          end

          redirect_to '/'
        end
      end
    end
  end
end
