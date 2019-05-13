# frozen_string_literal: true

module Api
  module V1
    module JobSeeker
      class UsersController < BaseController
        before_action :validate_schema
        def create
          valid, error = CreateUserForm.new(user_params).validate
          abort(422, error) unless valid

          user = CreateUser.new(user_params).call
          render json: user, status: :create
        end

        private

        def user_params
          params.permit(:first_name, :middle_name, :last_name, :avatar,
                        address: {}, education: {}, phone_numbers: {},
                        social_profiles: {})
        end
      end
    end
  end
end
