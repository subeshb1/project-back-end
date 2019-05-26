# frozen_string_literal: true

require 'faker'
  def create_a_user(params = {})
    user_params = {
      email: Faker::Internet.email,
      password: '123456',
      password_confirmation: '123456',
      role: 0
    }
    User.create!(user_params.merge!(params))
  end
