# frozen_string_literal: true

def create_a_user(params = {})
  require 'faker'
  user_params = {
    email: Faker::Internet.email,
    password: '12345678',
    password_confirmation: '12345678',
    role: 0
  }
  User.create!(user_params.merge!(params))
end

def get_auth(user)
  JsonWebToken.encode(user_id: user.uid)
end

# def create_job_seeker_profile(user)
#   user = create_a_user  unless user
  

# end

# def create_work_experience(user)
#   user.work_experiences << WorkExperience.create(
    
#   )
# end
