# frozen_string_literal: true

class ChannelsRepository < Hanami::Repository
  associations do
    has_many :channel_subscriptions
  end

  def from_slack_id(slack_id)
    channels.where(slack_id: slack_id).one
  end

  def notifiable(organisation, incident)
    channels.join(channel_subscriptions).where(
      organisation_id: organisation.id,
      escalation_policy_id: incident.escalation_policy_id
    )
  end
end

