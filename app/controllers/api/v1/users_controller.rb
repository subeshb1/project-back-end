# frozen_string_literal: true

module Api
  module V1
    class UsersController < BaseController
      def create
        valid, error = CreateUserForm.new(user_params).validate
        api_error(422, error) unless valid

        user = CreateUser.new(user_params).call
        render json: user, status: :create, serializer: UserSerializer
      end

      private

      def user_params
        params.dup.permit(:email, :password, :confirm_password, :type)
      end
    end
  end
end
