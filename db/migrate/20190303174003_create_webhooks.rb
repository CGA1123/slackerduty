# frozen_string_literal: true

class CreateWebhooks < ActiveRecord::Migration[5.2]
  def change
    create_table :webhooks do |t|
      t.string :webhook_id, unique: true, null: false

      t.timestamps
      t.index :webhook_id, unique: true
    end
  end
end
