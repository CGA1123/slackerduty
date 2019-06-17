# frozen_string_literal: true

class MessageRepository < Hanami::Repository
  def for_incident_id(incident_id)
    messages.where(incident_id: incident_id)
  end
end
