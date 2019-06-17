# frozen_string_literal: true

require 'hanami/interactor'

module Slackerduty
  module Operations
    class FetchUserPagerDutyId
      include Hanami::Interactor

      attr_reader :user_repository

      def initialize(user_repository: UserRepository.new)
        @user_repository = user_repository
      end

      def call(user, organisation)
        user_id = organisation
          .pager_duty_client
          .fetch_users(user.email)
          .body
          .fetch('users')
          .first
          &.fetch('id')

        error! 'PagerDuty user not found!' unless user_id

        user_repository.update(user.id, pager_duty_id: user_id)
      rescue Faraday::Error
        error 'PagerDuty HTTP Error'
      end
    end
  end
end
