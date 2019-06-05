# frozen_string_literal: true

module Actions
  class PagerDuty
    include ::ActionHandler

    def call
      return 403 unless authorised_request?

      JSON
        .parse(body)
        .fetch('messages')
        .group_by { |message| message.dig('incident', 'id') }
        .transform_values(&:last)
        .values
        .each { |message| Workers::NotifySlack.perform_async(message) }

      204
    end

    def authorised_request?
      theirs = context.request.get_header('HTTP_AUTHORIZATION').to_s
      ours = "Basic #{Base64.strict_encode64("#{Slackerduty::PAGERDUTY_USER}:#{Slackerduty::PAGERDUTY_PASS}")}"

      Rack::Utils.secure_compare(theirs, ours)
    end
  end
end
