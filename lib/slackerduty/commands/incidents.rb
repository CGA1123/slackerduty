# frozen_string_literal: true

require_relative '../slack_responder'

module Slackerduty
  module Commands
    class Incidents
      include SlackResponder

      def execute; end
    end
  end
end
