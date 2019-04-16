# frozen_string_literal: true

class AddUserIdToMessages < ActiveRecord::Migration[5.2]
  def change
    add_column :messages, :slack_user_id, :string, null: false
  end
end
