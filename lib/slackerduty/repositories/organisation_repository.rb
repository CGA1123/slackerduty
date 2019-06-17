# frozen_string_literal: true

class OrganisationRepository < Hanami::Repository
  def from_pager_duty_token(token)
    organisations
      .where(pager_duty_token: token)
      .one
  end

  def from_slack_id(slack_id)
    organisations
      .where(slack_id: slack_id)
      .one
  end
end
