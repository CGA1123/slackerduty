# frozen_string_literal: true

Hanami::Model.migration do
  change do
    create_table :messages do
      primary_key %i[slack_channel slack_ts]

      column :slack_ts, String, null: false
      column :slack_channel, String, null: false
      column :incident_id, String, null: false

      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false

      index :incident_id
    end
  end
end
