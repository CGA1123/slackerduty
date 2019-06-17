# frozen_string_literal: true

require 'hanami/interactor'

module Slackerduty
  module Commands
    class Off
      include Hanami::Interactor

      expose(:message)

      attr_reader :user_repository

      def initialize(user_repository: UserRepository.new)
        @user_repository = user_repository
      end

      def call(user_id, _organisation, _args)
        user = user_repository.find(user_id)

        if user
          user_repository.update(user.id, notifications_enabled: false)
          @message = ':mute:'
        else
          @message = "You're account has not been linked. `/sd link`"
        end
      end
    end
  end
end
