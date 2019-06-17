# frozen_string_literal: true

module Slackerduty
  module Blocks
    class IncidentStatus
      attr_reader :incident, :log_entries

      def initialize(incident)
        @incident = incident
      end

      def present?
        incident.acknowledged? || incident.resolved?
      end

      def to_slack
        @to_slack ||=
          Slack::BlockKit::Layout::Context.new do |context|
            context.mrkdwn(text: text)
          end
      end

      def as_json(*)
        to_slack.as_json
      end

      private

      def text
        if incident.resolved?
          "Resolved By: #{agent_reference(incident.resolver).first}"
        else
          "Acks: #{agent_reference(*incident.acknowledgers).join(',')}"
        end
      end

      def agent_reference(*agents)
        repo = UserRepository.new

        agents.map do |agent|
          if agent[:type] == 'user_reference' || agent[:type] == 'user'
            user = repo.from_pager_duty_id(agent[:id])

            user ? "<@#{user.slack_id}>" : agent[:summary]
          else
            agent[:summary]
          end
        end
      end
    end
  end
end
