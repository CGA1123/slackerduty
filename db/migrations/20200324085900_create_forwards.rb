Hanami::Model.migration do
  change do
    create_table :forwards do
      foreign_key :organisation_id, :organisations
      column :channel_id, String, null: false
      column :incident_id, String, null: false
      column :timestamp, DateTime, null: false
    end
  end
end
