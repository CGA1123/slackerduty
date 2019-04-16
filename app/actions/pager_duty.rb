# frozen_string_literal: true

module Actions
  class PagerDuty
    include ::ActionHandler

    def call
      json = JSON.parse(body)

      return 403 unless authorised_request?

      json['messages']
        .map { |m| m['incident']['id'] }
        .uniq
        .each { |id| Workers::NotifySlack.perform_async(id) }

      204
    end

    def authorised_request?
      theirs = context.request.get_header('HTTP_AUTHORIZATION').to_s
      ours = "Basic #{Base64.strict_encode64("#{Slackerduty::PAGERDUTY_USER}:#{Slackerduty::PAGERDUTY_PASS}")}"

      Rack::Utils.secure_compare(theirs, ours)
    end
  end
end
