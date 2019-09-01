# frozen_string_literal: true

require 'hanami/interactor'

module Slackerduty
  module Commands
    class Link
      include Hanami::Interactor

      expose(:message)

      def call(user_id, organisation, *)
        user = Slackerduty::Operations::CreateUserFromSlackId.new.call(
          organisation: organisation,
          slack_id: user_id
        ).user

        pager_duty_op = Slackerduty::Operations::FetchUserPagerDutyId.new.call(
          user,
          organisation
        )

        @message = if pager_duty_op.success?
                     "All set, `<#{user.email}>`"
                   else
                     pager_duty_op.error
                   end
      end
    end
  end
end
