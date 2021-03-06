# frozen_string_literal: true

module Web
  module Controllers
    module Home
      class Logout
        include Web::Action

        before :authenticate_user!

        def call(*)
          warden.logout
          redirect_to '/'
        end
      end
    end
  end
end
