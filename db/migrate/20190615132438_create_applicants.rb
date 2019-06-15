# frozen_string_literal: true

class CreateApplicants < ActiveRecord::Migration[5.2]
  def change
    create_table :applicants do |t|
      t.integer :status, limit: 1
      t.belongs_to :user, foreign_key: true
      t.belongs_to :job, foreign_key: true
      t.datetime :applied_date
      t.jsonb :answers, default: {}
      t.timestamps
    end
    add_index :applicants, [:job_id, :user_id], unique: true
  end
end
