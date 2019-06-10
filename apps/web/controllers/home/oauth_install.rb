# frozen_string_literal: true

module Web
  module Controllers
    module Home
      class OauthInstall
        include Web::Action

        params { required(:code) { filled? & str? } }

        def call(params)
          if params.valid?
            operation = Slackerduty::Operations::InstallViaOAuth.new.call(params[:code])

            warden.set_user(operation.user) if operation.success?
          end

          redirect_to '/'
        end
      end
    end
  end
end
