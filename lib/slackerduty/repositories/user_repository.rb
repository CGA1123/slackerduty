# frozen_string_literal: true

class UserRepository < Hanami::Repository
  def from_slack_id(slack_id)
    users.where(slack_id: slack_id).one
  end

  def from_pager_duty_id(pager_duty_id)
    users.where(pager_duty_id: pager_duty_id)
  end

  def notifiable(organisation)
    users.where(notifications_enabled: true, organisation_id: organisation.id)
  end
end
