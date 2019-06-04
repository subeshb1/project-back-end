class CreateJobs < ActiveRecord::Migration[5.2]
  def change
    create_table :jobs do |t|
      t.string :uid, unique: true
      t.text :description
      t.string :title
      t.float :min_salary
      t.float :max_salary
      t.jsonb :features, default: {}
      t.integer :open_seats, default: 1
      t.belongs_to :job_provider, index: true
      t.timestamps
    end
  end
end
