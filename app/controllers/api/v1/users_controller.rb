# frozen_string_literal: true

module Api
  module V1
    class UsersController < BaseController
      before_action :validate_schema, only: [:create]
      before_action :authenticate_request!, only: [:role]
      def create
        valid, error = CreateUserForm.new(user_params).validate
        api_error(422, error) unless valid

        user = CreateUser.new(user_params).call
        auth_token = JsonWebToken.encode(user_id: user.uid)
        render json: { auth_token: auth_token, email: user.email, uid: user.uid, role: User::ROLES[user.role] }, status: :ok
      end

      def role
        role = current_user.nil? ? nil : User::ROLES[current_user.role]
        render json: { role: role }, status: :ok, serializer: nil
      end

      private

      def user_params
        params.dup.permit(:email, :password, :confirm_password, :type)
      end
    end
  end
end
