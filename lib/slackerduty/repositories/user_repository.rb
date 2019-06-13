# frozen_string_literal: true

class UserRepository < Hanami::Repository
  def from_slack_id(slack_id)
    users
      .where(slack_id: slack_id)
      .one
  end

  def with_notifications_enabled
    users.where(notifications_enabled: true)
  end
end
