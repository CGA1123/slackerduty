# frozen_string_literal: true

module Slackerduty
  module Blocks
    class IncidentActions
      attr_reader :incident

      def initialize(incident)
        @incident = incident
      end

      def present?
        !possible_actions.empty?
      end

      def to_slack
        @to_slack ||=
          Slack::BlockKit::Layout::Actions.new do |actions|
            possible_actions.each do |action|
              actions.button(
                text: action.capitalize,
                action_id: action.to_s,
                value: "#{incident['id']}--#{incident['type']}"
              )
            end
          end
      end

      def as_json(*)
        to_slack.as_json
      end

      private

      def possible_actions
        @possible_actions ||=
          case incident['status']
          when 'triggered'
            %w[acknowledge resolve]
          when 'acknowledged'
            %w[acknowledge resolve]
          else
            []
          end
      end
    end
  end
end
