# frozen_string_literal: true

module Api
  module V1
    class ProfileController < BaseController
      # before_action :check_user
      before_action :authenticate_request!, only: %i[basic_info show_basic_info]
      before_action :validate_schema, only: %i[basic_info]

      def basic_info
        valid, error = UpdateBasicInformationForm.new(profile_params, current_user)
                                                 .validate
        api_error(422, error) unless valid
        profile = UpdateBasicInformation.new(profile_params, current_user).call
        render json: profile, status: 200
      end

      def show_basic_info
        render json: current_user.basic_information, status: 200
      end

      private

      def profile_params
        params.dup.permit(:name, :avatar, :gender, :organization_type, :website, :description,
                          :birth_date, :established_date, address: {},
                                                          phone_numbers: {}, social_accounts: {})
      end
    end
  end
end
