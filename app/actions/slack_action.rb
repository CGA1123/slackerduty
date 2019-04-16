# frozen_string_literal: true

module Actions
  class SlackAction
    include ::ActionHandler

    def call
      with_slack_verification do
        json = JSON.parse(context.params['payload'])

        Workers::ProcessSlackAction.perform_async(json)

        204
      end
    end
  end
end
