# frozen_string_literal: true

module Api
  module V1
    class ProfileController < BaseController
      # before_action :check_user
      before_action :authenticate_request!
      before_action :validate_schema, only: %i[basic_info education]

      # Baisc Info
      def basic_info
        valid, error = UpdateBasicInformationForm.new(basic_info_params, current_user)
                                                 .validate
        api_error(422, error) unless valid
        basic_info = UpdateBasicInformation.new(basic_info_params, current_user).call
        render json: basic_info, status: 200
      end

      def show_basic_info
        render json: current_user.basic_information, status: 200
      end

      # Education
      def education
        authorize! :update_education, current_user
        educations = UpdateEducation.new(current_user, education_params).call
        render json: educations, status: 200
      end

      def show_education
        render json: current_user.educations, status: 200
      end

      private

      def education_params
        params.permit(educations: [:degree, :start_date, :end_date, :program, categories: []])
      end

      def basic_info_params
        params.dup.permit(:name, :avatar, :gender, :organization_type, :website, :description,
                          :birth_date, :established_date, address: {},
                                                          phone_numbers: {}, social_accounts: {})
      end
    end
  end
end
