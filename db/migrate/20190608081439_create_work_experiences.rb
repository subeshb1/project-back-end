class CreateWorkExperiences < ActiveRecord::Migration[5.2]
  def change
    create_table :work_experiences do |t|
      t.string :organization_name
      t.string :job_title
      t.string :title
      t.string :level
      t.date :start_date
      t.date :end_date
      t.text :description
      t.belongs_to :user
      t.timestamps
    end
    create_table :categories_work_experiences do |t|
      t.belongs_to :category, foreign_key: true
      t.belongs_to :work_experience, foreign_key: true
    end
  end
end
