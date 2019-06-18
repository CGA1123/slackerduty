# frozen_string_literal: true

Hanami::Model.migration do
  change do
    alter_table :incidents do
      add_column :escalation_policy_id, String, null: false
    end
  end
end
