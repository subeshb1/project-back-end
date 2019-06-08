class CreateBasicInformations < ActiveRecord::Migration[5.2]
  def change
    create_table :basic_informations do |t|
      t.string :name
      t.datetime :birth_date
      t.jsonb :phone_numbers, default: {}
      t.jsonb :social_accounts, default: {}
      t.integer :role, limit: 1
      t.text :description
      t.string :website
      t.belongs_to :user, foreign_key: true
      t.jsonb :address, default: {}
      t.timestamps
    end
    create_table :categories_basic_informations, id: false do |t|
      t.belongs_to :category, index: true, foreign_key: true
      t.belongs_to :basic_information, index: true, foreign_key: true
    end
  end
end
