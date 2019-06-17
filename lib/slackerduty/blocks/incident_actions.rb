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
            possible_actions.each do |action, style|
              actions.button(
                text: action.capitalize,
                style: style,
                action_id: action,
                value: incident.id
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
          case incident.status
          when 'triggered'
            { 'acknowledge' => nil, 'resolve' => 'primary' }
          when 'acknowledged'
            { 'acknowledge' => nil, 'resolve' => 'primary' }
          else
            []
          end
      end
    end
  end
end
