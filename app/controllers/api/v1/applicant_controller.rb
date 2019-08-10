# frozen_string_literal: true

module Api
  module V1
    class ApplicantController < BaseController
      before_action :validate_schema, only: []
      before_action :authenticate_request!
      before_action :check_job, only: %i[apply show approve reject]

      def apply
        authorize! :apply_jobs, current_user
        valid, error = CheckEligibilityForm.new(current_user, @job).validate
        api_error(422, error) unless valid

        ApplyJob.new(current_user, @job).call
        render json: { message: 'Successfully Applied!' }, status: :created
      end

      def show
        authorize! :modify_applicants, current_user
        page, per_page = extract_page_details(params)
        applicants = GetApplicantList.new(@job, show_params).call.page(page).per(per_page)
        render json: {
          data: ActiveModel::SerializableResource.new(
            applicants,
            each_serializer: ApplicantSerializer
          ),
          meta: fetch_meta(applicants)
        }, status: :ok
      end

      def approve
        authorize! :modify_applicants, current_user
        ApproveRejectApplicant.new(@job, approve_params, true).call
        render json: { message: 'Successfully Approved!' }, status: :ok
      end

      def reject
        authorize! :modify_applicants, current_user
        ApproveRejectApplicant.new(@job, approve_params).call
        render json: { message: 'Successfully Rejected!' }, status: :ok
      end

      def view_applied
        authorize! :view_applied, current_user
        page, per_page = extract_page_details(params)
        applied_jobs = current_user.applications.order(created_at: :desc).page(page).per(per_page)
        render json: {
          data: ActiveModel::SerializableResource.new(
            applied_jobs,
            each_serializer: ApplicantSerializer
          ),
          meta: fetch_meta(applied_jobs)
        }, status: :ok
      end

      private

      def show_params
        params.dup.permit(:name, :experience, :max_age, :order,
                          :order_by, :end_date, :start_date,
                          :min_age, degree: [], program: [], skills:[], gender: [], status: [])
      end

      def approve_params
        params.dup.permit(:id, applicant_id: [])
      end

      def apply_params
        params.dup.permit(:id)
      end

      def check_job
        @job = Job.where(uid: apply_params[:id]).last
        return if @job

        error_message = { message: 'Job not found!' }
        api_error(403, error_message)
      end
    end
  end
end
