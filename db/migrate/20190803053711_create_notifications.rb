class CreateNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :notifications do |t|
      t.string :from
      t.string :to
      t.text :message
      t.belongs_to :user, foreign_key: true
      t.integer :status
      t.timestamps
    end
  end
end
