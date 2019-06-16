# frozen_string_literal: true

module Web
  module Views
    module Organisations
      class Edit
        include Web::View

        def form
          form_for :organisation, '/organisation', method: :patch do
            text_field :pager_duty_api_key

            submit 'Update!'
          end
        end
      end
    end
  end
end
