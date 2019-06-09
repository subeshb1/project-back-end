class CreateCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :categories do |t|
      t.string :name, unique: true
      t.timestamps
    end

    
    create_table :categories_jobs, id: false do |t|
      t.belongs_to :category, index: true, foreign_key: true
      t.belongs_to :job, index: true, foreign_key: true
    end
  end
end
