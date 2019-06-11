# frozen_string_literal: true

class Organisation < Hanami::Entity
  def slack_client
    Slackerduty::SlackApi.new(slack_bot_token).client
  end

  def pagerduty_client
    Slackerduty::PagerDutyApi.new(pager_duty_token)
  end
end
