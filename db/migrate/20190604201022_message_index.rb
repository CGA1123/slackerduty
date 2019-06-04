class MessageIndex < ActiveRecord::Migration[5.2]
  def change
    add_index :messages, :incident_id
  end
end
