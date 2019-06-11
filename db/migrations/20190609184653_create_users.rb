# frozen_string_literal: true

Hanami::Model.migration do
  change do
    create_table :users do
      primary_key :id
      foreign_key(:organisation_id, :organisations)

      column :email, String, null: false
      column :slack_id, String, null: false
      column :pager_duty_id, String

      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false

      index :email, unique: true
      index :slack_id, unique: true
      index :pager_duty_id, unique: true
    end
  end
end
