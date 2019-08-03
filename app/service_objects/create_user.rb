# frozen_string_literal: true

class CreateUser
  attr_reader :params

  MESSAGE = [
    %(<h1>Welcome to Hamro Job</h1>
      <p>Start filling your profile and Search for Jobs!</p>
      <p><a href="/search">Search Jobs</a></p>
      <p><a href="/jobseeker/profile">Complete Profile</a></p>
      <p>Thank you!</p>
    ),
    %('<h1>Welcome to Hamro Job</h1>
      <p>Start filling your profile and Create Job Vacancies!</p>
      <p><a href="/jobprovider/jobs">Create Jobs</a></p>
      <p><a href="/jobprovider/profile">Complete Profile</a></p>
      <p>Thank you!</p>
    )
  ].freeze

  def initialize(params = {})
    @params = params
  end

  def call
    user = User.new(email: params[:email], password: params[:password],
                    password_confirmation: params[:confirm_password],
                    role: User::ROLES.key(params[:type]))
    user.save!
    CreateNotification.new(user, 'hamro_job@gmail.com', user.email, MESSAGE[user.role]).call
    user.reload
  end
end
