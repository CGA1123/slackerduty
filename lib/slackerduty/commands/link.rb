# frozen_string_literal: true

require 'hanami/interactor'

module Slackerduty
  module Commands
    class Link
      include Hanami::Interactor

      expose(:message)

      def call(user_id, organisation, _args)
        user = Slackerduty::Operations::CreateUserFromSlackId.new.call(
          organisation: organisation,
          slack_id: user_id
        ).user

        @message = "All set, `<#{user.email}>`"
      end
    end
  end
end
