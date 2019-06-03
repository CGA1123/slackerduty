# frozen_string_literal: true

class AddUniqueIndexToSubscriptions < ActiveRecord::Migration[5.2]
  def change
    add_index :subscriptions, %i[user_id escalation_policy_id], unique: true
  end
end
