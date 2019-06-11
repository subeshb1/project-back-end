# frozen_string_literal: true

module Api
  module V1
    module Jobprovider
      class JobController < BaseController
        before_action :authenticate_request!
        before_action :validate_schema, only: [:create]

        def create
          authorize! :create_job, current_user
          valid, error = CreateJobForm.new(current_user, create_params).validate
          api_error(422, error) unless valid

          job = CreateJob.new(current_user, create_params).call
          render json: job, status: :ok
        end

        def update; end

        def index
          page, per_page = extract_page_details(params)
          jobs = GetList
        end

        def show
          authorize! :view_job, current_user
          render json: Job.where(uid: show_params[:id], user_id: current_user.id), status: :ok
        end

        private

        def show_params
          params.permit(:id)
        end

        def create_params
          params.permit(:job_title, :open_seats, :level, :min_salary,
                        :max_salary,
                        :description, :job_type, :application_deadline,
                        categories: [],
                        questions: %i[question_type question options],
                        job_specifications: {})
        end
      end
    end
  end
end
