# frozen_string_literal: true

require 'hanami/interactor'

module Slackerduty
  module Commands
    class On
      include Hanami::Interactor

      expose(:message)

      attr_reader :user_repository

      def initialize(user_repository: UserRepository.new)
        @user_repository = user_repository
      end

      def call(user_id, _organisation, _args)
        user = user_repository.from_slack_id(user_id)

        if user
          user_repository.update(user.id, notifications_enabled: true)
          @message = ':loud_sound:'
        else
          @message = "You're account has not been linked. `/sd link`"
        end
      end
    end
  end
end
