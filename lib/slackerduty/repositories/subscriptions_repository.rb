# frozen_string_literal: true

class SubscriptionsRepository < Hanami::Repository
  def for_user(user)
    subscriptions.where(user_id: user.id)
  end
end
