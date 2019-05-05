# frozen_string_literal: true

class CreateApiKeys < ActiveRecord::Migration[5.0]
  def change
    create_table :api_keys do |t|
      t.jsonb :app_info, null: false, default: {}
      t.string :token, null: false
    end
  end
end
