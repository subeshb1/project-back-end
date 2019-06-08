class CreateApplicants < ActiveRecord::Migration[5.2]
  def change
    create_table :applicants do |t|
      t.integer :status, limit: 1
      t.belongs_to :user, foreign_key: true
      t.belongs_to :job, foreign_key: true
      t.timestamps
    end
  end
end
