# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :slack_id, null: false
      t.string :pagerduty_id, null: false
      t.boolean :notifications_enabled, null: false, default: false

      t.timestamps
    end
  end
end
