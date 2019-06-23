# frozen_string_literal: true

class IncidentRepository < Hanami::Repository
  def active(organisation)
    incidents.where(status: ['triggered', 'acknowledged'], organisation_id: organisation.id)
  end
end
