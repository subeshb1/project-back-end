# frozen_string_literal: true

class CreateUser
  attr_reader :params

  def initialize(params = {})
    @params = params
  end

  def call
    user = User.new(email: params[:email], password: params[:password],
                    password_confirmation: params[:confirm_password])
    user.save!
    user.reload
  end
end
