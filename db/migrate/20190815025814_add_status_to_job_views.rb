# frozen_string_literal: true

class AddStatusToJobViews < ActiveRecord::Migration[5.2]
  def change
    add_column :job_views, :status, :integer, default: 0, limit: 1
  end
end
