# frozen_string_literal: true

class RemoveColumns < ActiveRecord::Migration[5.2]
  def change
    remove_column :messages, :webhook_id
    remove_column :messages, :slack_user_id
    remove_column :messages, :last_status_change_at

    drop_table :webhooks
  end
end
