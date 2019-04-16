# frozen_string_literal: true

class AddPayloadToWebhooks < ActiveRecord::Migration[5.2]
  def change
    add_column :webhooks, :payload, :json
  end
end
