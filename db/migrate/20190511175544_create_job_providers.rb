class CreateJobProviders < ActiveRecord::Migration[5.2]
  def change
    create_table :job_providers do |t|
      t.string :name
      t.jsonb :address, default: {}
      t.jsonb :phone_numbers, default: {}
      t.jsonb :social_profiles, default: {}
      t.references :user
      t.timestamps
    end
  end
end
