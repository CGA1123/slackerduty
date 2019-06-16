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
          organisation = OrganisationRepository.new.find(
            current_user.organisation_id
          )

          if params.valid?
            update = Slackerduty::Operations::UpdatePagerDutyToken.new.call(
              organisation: organisation,
              token: params[:organisation][:pager_duty_api_key]
            )

            if update.success?
              flash[:notice] = 'Success!'
            else
              flash[:error] = 'Token is invalid.'
            end

            redirect_to '/organisation'
          else
            flash[:error] = 'No token passed!'
            redirect_to '/organisation'
          end
        end
      end
    end
  end
end
