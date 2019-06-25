# frozen_string_literal: true

class ChannelSubscriptionsRepository < Hanami::Repository
  def for_channel(channel)
    channel_subscriptions.where(channel_id: channel.id)
  end

  def find_by_escalation_policy(channel, policy)
    for_channel(channel).where(escalation_policy_id: policy).one
  end
end
