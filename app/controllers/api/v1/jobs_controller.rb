# frozen_string_literal: true

module Api
  module V1
    class JobsController < BaseController
      before_action :authenticate_request!
      before_action :validate_schema, only: %i[index]
      before_action :check_job, only: %i[show]

      def index
        page, per_page = extract_page_details(params)
        jobs = GetJobList.new(job_list_params).call.page(page).per(per_page)
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
        unless current_user.viewed_jobs.include?(@job) && current_user.job_seeker?
          current_user.viewed_jobs << @job
        end
        render json: @job, status: :ok
      end

      private

      def job_list_params
        params.permit(
          :time_min, :time_max,
          :min_salary,
          :max_salary, :job_title,job_provider_id:[], level: [], job_type: [],
                                   categories: [], open_seats: {}
        )
      end

      def show_params
        params.permit(:id)
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
