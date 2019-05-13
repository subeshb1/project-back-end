# frozen_string_literal: true

class UsersController < API::V1::BaseController
  def create
    valid, error = CreateUserForm.new(user_params).validate
    api_error(422, error) unless valid

    # user = CreateUser.new(user_params).call
    render json: {}, status: :create
  end

  private

  def user_params
    params.permit(:email, :password, :confirm_password, :type)
  end
end
