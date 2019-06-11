# frozen_string_literal: true

require 'hanami/interactor'

module Slackerduty
  module Workers
    class Notify
      include Hanami::Interactor

      def initialize(message_repository:)
        @message_repository = message_repository
      end

      def call; end
    end
  end
end
