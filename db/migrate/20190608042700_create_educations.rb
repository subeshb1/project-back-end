class CreateEducations < ActiveRecord::Migration[5.2]
  def change
    create_table :educations do |t|
      t.string :degree
      t.string :program
      t.datetime :start_date
      t.datetime :end_date
      t.belongs_to :user, foreign_key: true
      t.timestamps
    end
    create_table :categories_educations do |t|
      t.belongs_to :category, index: true, foreign_key: true
      t.belongs_to :education, index: true, foreign_key: true
    end
  end
end
