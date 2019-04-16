# frozen_string_literal: true

module Actions
  class Root
    include ::ActionHandler

    def call
      context.headers['Content-Type'] = 'text/plain; charset=utf-8'

      <<~INFO
        PagerDuty → Slack 📟
        slackerduty is up and running.
      INFO
    end
  end
end
