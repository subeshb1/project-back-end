# frozen_string_literal: true

class AddRoleToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :role, :integer, :default => User::JOB_SEEKER
  end
end
