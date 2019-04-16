# frozen_string_literal: true

class AddUserToMessages < ActiveRecord::Migration[5.2]
  def change
    add_column :messages, :user_id, :int, null: false
    add_foreign_key :messages, :users
  end
end
