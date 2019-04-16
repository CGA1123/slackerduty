# frozen_string_literal: true

module Actions
  class SlackCommand
    include ::ActionHandler

    def call
      with_slack_verification do
        Workers::ProcessSlackCommand.perform_async(context.params)

        204
      end
    end
  end
end
