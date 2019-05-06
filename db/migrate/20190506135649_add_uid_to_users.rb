# frozen_string_literal: true

class AddUidToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :uid, :string, null: false, unique: true
  end
end
