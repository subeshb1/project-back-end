class CreateExaminees < ActiveRecord::Migration[5.2]
  def change
    create_table :examinees do |t|
      t.belongs_to :user, foreign_key: true
      t.belongs_to :exam, foreign_key: true
      t.float :score
      t.timestamps
    end
  end
end
