# frozen_string_literal: true

class CreateMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :messages do |t|
      t.string :webhook_id, null: false
      t.string :incident_id, null: false
      t.string :slack_ts, null: false
      t.string :slack_channel, null: false
      t.timestamp :last_status_change_at, null: false

      t.timestamps
    end
  end
end
