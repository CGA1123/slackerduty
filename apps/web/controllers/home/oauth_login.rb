# frozen_string_literal: true

module Web
  module Controllers
    module Home
      class OauthLogin
        include Web::Action

        params { required(:code) { filled? & str? } }

        def call(params)
          if params.valid?
            operation =
              Slackerduty::Operations::LoginViaOAuth
              .new
              .call(params[:code])

            redirect_to "/?oauth_success=#{operation.success?}"
          else
            redirect_to '/'
          end
        end
      end
    end
  end
end
