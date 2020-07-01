# frozen_string_literal: true

require 'hanami/interactor'

module Slackerduty
  module Operations
    class ProcessSlackEvent
      include Hanami::Interactor

      def initialize(organisation_repository: OrganisationRepository.new)
        @organisation_repository = organisation_repository
      end

      def call(event:)
        return unless supported?(event)

        org = organisation_repository.from_slack_id(event['team_id'])

        error! 'org not found' unless org

        org.slack_client.views_publish(
          user_id: event['user'],
          view: Slack::BlockKit.home(
            blocks: home_blocks
          ).as_json
        )
      end

      private

      def home_blocks
        Slack::BlockKit.blocks do |blocks|
          blocks.section do |section|
            section.mrkdwn(text: 'slackerduty home (wip)')
            section.image(
              url: 'https://git.io/JJUOR',
              alt_text: 'wip'
            )
          end
        end
      end

      def supported?(event)
        event['type'] == 'app_home_opened'
      end
    end
  end
end
