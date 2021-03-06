# frozen_string_literal: true

class Organisation < Hanami::Entity
  def slack_client
    Slackerduty::SlackApi.new(slack_bot_token).client
  end

  def pager_duty_client
    Slackerduty::PagerDutyApi.new(pager_duty_api_key)
  end
end
