# frozen_string_literal: true

module Web
  module Controllers
    module Organisations
      class Edit
        include Web::Action

        before :authenticate_user!

        def call(params)
        end
      end
    end
  end
end
