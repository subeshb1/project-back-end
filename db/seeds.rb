# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
ApiKey.new(token: 'development').save!

# categories = [
#   'Science and Technology',
#   'Pharmacy',
#   'Nursing',
#   'Management',
#   'Medicine and Health Care',
#   'Law, public safety and security',
#   'Engineering',
#   'Computer and IT',
#   'Education',
#   'Ayurved',
#   'Agriculture'
# ].sort

# categories.each do |category|
#   Category.create!(name: category)
# end
