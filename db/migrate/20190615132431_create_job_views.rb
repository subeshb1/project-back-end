class CreateJobViews < ActiveRecord::Migration[5.2]
  def change
    create_table :job_views do |t|
      t.belongs_to :job, index: true, foreign_key: true
      t.belongs_to :user, index: true, foreign_key: true
      t.timestamps
    end
    add_index :job_views, [:job_id, :user_id], unique: true
  end
end
