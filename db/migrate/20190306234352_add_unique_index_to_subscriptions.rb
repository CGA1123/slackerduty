class AddUniqueIndexToSubscriptions < ActiveRecord::Migration[5.2]
  def change
    add_index :subscriptions, [:user_id, :escalation_policy_id], unique: true
  end
end
