# frozen_string_literal: true

module Api
  module V1
    class ProfilesController < BaseController
      # before_action :check_user
      before_action :authenticate_request!, only: %i[update index]
      before_action :validate_schema, only: %i[update]

      def update
        valid, error = UpdateProfileForm.new(profile_params, current_user)
                                        .validate
        api_error(422, error) unless valid
        profile = UpdateProfile.new(profile_params, current_user).call
        render json: profile, status: 200
      end

      def index
        render json: current_user.profile, status: 200
      end

      private

      def profile_params
        params.dup.permit(:first_name, :middle_name, :last_name, :avatar,
                          :company_name, address: {}, education: {},
                                         phone_numbers: {}, social_profiles: {})
      end
    end
  end
end
