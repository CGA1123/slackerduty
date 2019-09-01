# frozen_string_literal: true

Hanami::Model.migration do
  change do
    create_table :channels do
      foreign_key :organisation_id, :organisations
      column :id, String, null: false, primary_key: true
      column :name, String, null: false
    end

    create_table :channel_subscriptions do
      foreign_key :channel_id, :channels, type: String
      primary_key %i[channel_id escalation_policy_id]
      column :escalation_policy_id, String, null: false
    end
  end
end
