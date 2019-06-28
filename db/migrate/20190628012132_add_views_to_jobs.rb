# frozen_string_literal: true

class AddViewsToJobs < ActiveRecord::Migration[5.2]
  def change
    add_column :jobs, :views, :integer, default: 0
  end
end
