# frozen_string_literal: true

module Api
  module V1
    class ProfilesController < BaseController
      # before_action :check_user
      before_action :authenticate_request!, only: [:update]
      before_action :validate_schema
      def update
        valid, error = UpdateProfileForm.new(profile_params).validate
        abort(422, error) unless valid
        profile = UpdateProfile.new(profile_params, current_user).call
        render json: profile, status: 200
      end

      private

      def profile_params
        params.dup.permit(:first_name, :middle_name, :last_name, :avatar,
                          address: {}, education: {}, phone_numbers: {},
                          social_profiles: {})
      end

      def check_job_seeker
        User.where(uid: profile_params[:id])
      end
    end
  end
end
