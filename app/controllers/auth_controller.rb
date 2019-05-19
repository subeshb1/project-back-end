# frozen_string_literal: true

class AuthController < ApplicationController
  def login
    params = login_params
    user = User.where(email: params[:email]).first
    if user&.valid_password? params[:password]
      auth_token = JsonWebToken.encode(user_id: user.uid)
      render json: { auth_token: auth_token }, status: :ok
    else
      render json: { error: 'Invalid Email or Password' }, status: :unauthorized
    end
  end

  private

  def login_params
    params.permit(:email, :password)
  end
end
