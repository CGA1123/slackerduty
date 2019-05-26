# frozen_string_literal: true

require_relative '../slack_responder'

module Slackerduty
  module Actions
    class Forward
      include SlackResponder

      def execute
        pp @params['actions'].first['action_id']
      end
    end
  end
end
