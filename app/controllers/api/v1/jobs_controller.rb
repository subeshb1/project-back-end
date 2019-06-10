# frozen_string_literal: true

module Api
  module V1
    class JobsController < BaseController
      before_action :authenticate_request!, only: [:create]
      # before_action :validate_schema, only: [:create]

      def create
        authorize! :create_job, current_user
        valid, error = CreateJobForm.new(create_params).validate
        api_error(422, error) unless valid

        job = CreateJob.new(current_user, create_params).call
        render json: job, status: :ok
      end

      def update; end

      private

      def create_params
        params.permit
      end
    end
  end
end
