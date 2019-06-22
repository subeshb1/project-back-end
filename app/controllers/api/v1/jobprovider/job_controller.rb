# frozen_string_literal: true

module Api
  module V1
    module Jobprovider
      class JobController < BaseController
        before_action :authenticate_request!
        before_action :validate_schema, only: %i[create index]
        before_action :check_job, only: %i[update]

        def create
          authorize! :create_job, current_user
          valid, error = CreateJobForm.new(current_user, create_params).validate
          api_error(422, error) unless valid

          job = CreateJob.new(current_user, create_params).call
          render json: job, status: 201
        end

        def update
          authorize! :create_job, current_user
          render json: UpdateJob.new(@job, create_params).call, status: :ok
        end

        def index
          authorize! :view_job, current_user
          page, per_page = extract_page_details(params)
          jobs = GetJobList.new(job_list_params.merge!(job_provider_id: [current_user.uid])).call.page(page).per(per_page)
          render json: {

            data: ActiveModel::SerializableResource.new(
              jobs,
              each_serializer: LessJobSerializer
            ),
            meta: fetch_meta(jobs)
          }, status: :ok
        end

        def show
          authorize! :view_job, current_user
          render json: Job.where(uid: show_params[:id], user_id: current_user.id).last, status: :ok
        end

        private

        def job_list_params
          params.permit(
            :time_min, :time_max,
            :min_salary,
            :max_salary, :job_title, level: [], job_type: [],
                                     categories: [], open_seats: {}
          )
        end

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

        def check_job
          @job = Job.where(uid: params[:id]).last
          return if @job

          error_message = { message: 'Job not found!' }
          api_error(403, error_message)
        end
      end
    end
  end
end
