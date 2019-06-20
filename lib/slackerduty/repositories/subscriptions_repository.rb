# frozen_string_literal: true

class SubscriptionsRepository < Hanami::Repository
  def for_user(user)
    subscriptions.where(user_id: user.id)
  end

  def find_by_escalation_policy(user, policy)
    for_user(user).where(escalation_policy_id: policy).one
  end
end
