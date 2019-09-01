# frozen_string_literal: true

class ChannelRepository < Hanami::Repository
  associations do
    has_many :channel_subscriptions
  end

  def from_slack_id(slack_id)
    channels.where(id: slack_id).one
  end

  def for_organisation(organisation)
    aggregate(:channel_subscriptions)
      .where(organisation_id: organisation.id)
      .map_to(Channel)
  end

  def notifiable(organisation, incident)
    channels.join(channel_subscriptions).where(
      organisation_id: organisation.id,
      escalation_policy_id: incident.escalation_policy_id
    )
  end
end
