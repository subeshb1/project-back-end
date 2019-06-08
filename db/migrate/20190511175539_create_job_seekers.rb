class CreateJobSeekers < ActiveRecord::Migration[5.2]
  def change
    create_table :job_seekers do |t|
      t.string :first_name
      t.string :middle_name
      t.string :last_name
      t.jsonb :address, default: {}
      t.jsonb :education, default: {}
      t.jsonb :phone_numbers, default: {}
      t.jsonb :social_profiles, default: {}
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
