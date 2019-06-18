# frozen_string_literal: true

Hanami::Model.migration do
  change do
    create_table :subscriptions do
      foreign_key :user_id, :users
      primary_key %i[user_id escalation_policy_id]
      column :escalation_policy_id, String, null: false
      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
    end
  end
end
