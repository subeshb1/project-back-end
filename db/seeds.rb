# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
ApiKey.new(token: 'development').save!

categories = [
  'science and technology',
  'pharmacy',
  'nursing',
  'management',
  'medicine and health care',
  'law, public safety and security',
  'engineering',
  'computer and IT',
  'education',
  'ayurved',
  'agriculture'
]

categories.each do |category|
  Category.create!(name: category)
end
