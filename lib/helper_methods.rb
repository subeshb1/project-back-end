# frozen_string_literal: true

def create_a_user(params = {})
  require 'faker'
  user_params = {
    email: Faker::Internet.email,
    password: '123456',
    password_confirmation: '123456',
    role: 0
  }
  User.create!(user_params.merge!(params))
end
