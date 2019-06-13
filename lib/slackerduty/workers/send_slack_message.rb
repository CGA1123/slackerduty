# frozen_string_literal: true

require 'sidekiq'

module Slackerduty
  module Workers
    class SendSlackMessage
      include Sidekiq::Worker

      def perform(params)
        params.deep_symbolize_keys!

        message_repository = MessageRepository.new
        organisation = OrganisationRepository.new.find(params.fetch(:organisation_id))
        client = organisation.slack_client
        payload = params.slice(:blocks, :text, :channel, :ts).compact.merge(as_user: true)

        if update?(params)
          client.chat_update(payload)
        else
          slack_message = client.chat_postMessage(payload)

          message_repository.create(
            incident_id: params.fetch(:incident_id),
            slack_channel: slack_message['channel'],
            slack_ts: slack_message['ts']
          )
        end
      end

      def update?(params)
        !params.fetch(:ts).nil?
      end
    end
  end
end
