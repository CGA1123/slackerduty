# frozen_string_literal: true

class Organisation < Hanami::Entity
  def slack_client
    Slackerduty::SlackApi.new(slack_bot_token).client
  end
end
