# frozen_string_literal: true

class CreateExams < ActiveRecord::Migration[5.2]
  def change
    create_table :exams do |t|
      t.string :uid, unique: true
      t.string :name
      t.string :skill_name
      t.text :description
      t.jsonb :questions, null: false
      t.timestamps
    end
    create_table :categories_exams do |t|
      t.belongs_to :category, index: true, foreign_key: true
      t.belongs_to :exam, index: true, foreign_key: true
    end
  end
end
