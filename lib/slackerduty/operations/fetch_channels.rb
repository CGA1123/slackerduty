# frozen_string_literal: true

require 'hanami/interactor'

module Slackerduty
  module Operations
    class FetchChannels
      include Hanami::Interactor

      expose(:channels)

      attr_reader :repository

      def initialize(repository: ChannelSubscriptionRepository.new)
        @repository = repository
      end

      def call(organisation)
        @channels = nil
      end
    end
  end
end
