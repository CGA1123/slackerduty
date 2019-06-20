# frozen_string_literal: true

class UserRepository < Hanami::Repository
  associations do
    has_many :subscriptions
  end

  def from_slack_id(slack_id)
    users.where(slack_id: slack_id).one
  end

  def from_pager_duty_id(pager_duty_id)
    users.where(pager_duty_id: pager_duty_id).one
  end

  def notifiable(organisation, incident)
    users.joins(subscriptions).where(
      notifications_enabled: true,
      organisation_id: organisation.id,
      escalation_policy_id: incident.escalation_policy_id
    )
  end
end
