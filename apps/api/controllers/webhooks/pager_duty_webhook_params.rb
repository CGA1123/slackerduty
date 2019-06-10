# frozen_string_literal: true

module Api
  module Controllers
    module Webhooks
      # rubocop:disable Metrics/BlockLength
      class PagerDutyWebhookParams < Api::Action::Params
        EVENT_TYPES = [
          ACKNOWLEDGE = 'incident.acknowledge',
          ANNOTATE = 'incident.annotate',
          ASSIGN = 'incident.assign',
          DELEGATE = 'incident.delegate',
          ESCALATE = 'incident.escalate',
          RESOLVE = 'incident.resolve',
          TRIGGER = 'incident.trigger',
          UNACKNOWLEDGE = 'incident.unacknowledge'
        ].freeze

        INCIDENT_STATUSES = [
          ACKNOWLEDGED = 'acknowledged',
          RESOLVED = 'resolved',
          TRIGGERED = 'triggered'
        ].freeze

        params do
          required(:pager_duty_token) { filled? & str? }
          required(:messages).each do
            schema do
              required(:event) { filled? & included_in?(EVENT_TYPES) }
              required(:incident).schema do
                required(:id) { filled? & str? }
                required(:incident_number) { filled? & int? }
                required(:title) { filled? & str? }
                required(:status) { filled? & included_in?(INCIDENT_STATUSES) }
                required(:created_at) { filled? & date_time? }
                required(:summary) { filled? & str? }
                required(:type) { filled? & str? }
                required(:acknowledgements).each do
                  schema do
                    required(:acknowledger).schema do
                      required(:type) { filled? & str? }
                      required(:id) { filled? & str? }
                      required(:summary) { filled? & str? }
                    end
                  end
                end

                required(:service).schema do
                  required(:summary) { filled? & str? }
                end
              end

              required(:log_entries).each do
                schema do
                  required(:type) { filled? & str? }
                  required(:agent).schema do
                    required(:id) { filled? & str? }
                    required(:summary) { filled? & str? }
                  end
                end
              end
            end
          end
        end
      end
      # rubocop:enable Metrics/BlockLength
    end
  end
end
