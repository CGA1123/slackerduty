# frozen_string_literal: true

module Api
  module Controllers
    module Webhooks
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

        params do
          required(:pager_duty_token) { filled? & str? }
          required(:messages).each do
            schema do
              required(:event) { filled? & included_in?(EVENT_TYPES) }
              required(:incident).schema do
                required(:id) { filled? & str? }
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
    end
  end
end
