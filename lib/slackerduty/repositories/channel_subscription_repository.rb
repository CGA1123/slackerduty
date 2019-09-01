# frozen_string_literal: true

class ChannelSubscriptionRepository < Hanami::Repository
  def for_channel(channel_id)
    channel_subscriptions.where(channel_id: channel_id)
  end

  def find_by_escalation_policy(channel_id:, escalation_policy_id:)
    channel_subscriptions.where(
      channel_id: channel_id,
      escalation_policy_id: escalation_policy_id
    ).one
  end
end
