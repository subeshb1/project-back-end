class CreateCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :categories do |t|
      t.string :name, unique: true
      t.timestamps
    end

    create_join_table :categories, :jobs
  end
end
