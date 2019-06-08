# frozen_string_literal: true

Hanami::Model.migration do
  change do
    create_table :organisations do
      primary_key :id

      column :name, String, null: false
      column :slack_id, String, null: false
      column :slack_bot_id, String, null: false
      column :slack_bot_token, String, null: false
      column :pager_duty_token, String
      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false

      index :pager_duty_token, unique: true
      index :slack_id, unique: true
    end
  end
end
