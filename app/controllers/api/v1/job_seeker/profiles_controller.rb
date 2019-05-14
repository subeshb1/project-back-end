# frozen_string_literal: true

module Api
  module V1
    module JobSeeker
      class ProfilesController < BaseController
        before_action :check_job_seeker
        before_action :validate_schema

        def create
          valid, error = CreateUserForm.new(profile_params).validate
          # abort(422, error) unless valid

          # user = CreateUser.new(user_params).call
          # render json: user, status: :create
        end

        private

        def profile_params
          params.dup.permit(:first_name, :middle_name, :last_name, :avatar,
                            address: {}, education: {}, phone_numbers: {},
                            social_profiles: {})
        end

        def check_job_seeker
          User.where(uid: profile_params[:id], profile_params[:])
        end
      end
    end
  end
end
