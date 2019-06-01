# frozen_string_literal: true

module Api
  module V1
    class UsersController < BaseController
      before_action :validate_schema, only: [:create]
      before_action :authenticate_request!
      def create
        valid, error = CreateUserForm.new(user_params).validate
        api_error(422, error) unless valid

        user = CreateUser.new(user_params).call
        render json: user, status: :ok
      end

      def role
        authenticate_request!
        role = current_user.nil? ? nil : User::ROLE[current_user.role]
        render json: { role: role }, status: :ok, serializer: nil
      end

      private

      def user_params
        params.dup.permit(:email, :password, :confirm_password, :type)
      end
    end
  end
end
