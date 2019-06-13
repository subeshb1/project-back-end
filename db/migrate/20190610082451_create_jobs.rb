class CreateJobs < ActiveRecord::Migration[5.2]
  def change
    create_table :jobs do |t|
      t.string :uid, unique: true
      t.integer :status, limit: 1, default: 0
      t.string :job_title
      t.integer :open_seats, default: 1
      t.string :level
      t.float :min_salary
      t.float :max_salary
      t.string :job_type
      t.datetime :application_deadline
      t.text :description
      t.jsonb :job_specifications
      t.jsonb :questions
      t.datetime :completed_date
      t.belongs_to :user, index: true, foreign_key: true
      t.timestamps
    end

    create_table :categories_jobs do |t|
      t.belongs_to :category, index: true, foreign_key: true
      t.belongs_to :job, index: true, foreign_key: true
    end
  end
end
