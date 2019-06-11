# frozen_string_literal: true

Hanami::Model.migration do
  change do
    create_table :incidents do
      foreign_key :organisation_id, :organisations

      column :id, String, primary_key: true
      column :title, String, null: false
      column :type, String, null: false
      column :service_summary, String, null: false
      column :acknowledgers, 'jsonb', null: false, default: '[]'
      column :resolver, 'jsonb'
      column :alert, 'jsonb'
      column :status, String, null: false

      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
    end
  end
end
