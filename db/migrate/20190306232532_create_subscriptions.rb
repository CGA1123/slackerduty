# frozen_string_literal: true

class CreateSubscriptions < ActiveRecord::Migration[5.2]
  def change
    create_table :subscriptions do |t|
      t.string :escalation_policy_id, null: false
      t.integer :user_id, null: false
    end

    add_foreign_key :subscriptions, :users
  end
end
