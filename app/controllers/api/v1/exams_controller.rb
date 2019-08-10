# frozen_string_literal: true

module Api
  module V1
    class ExamsController < BaseController
      before_action :authenticate_request!

      def index
        render json: Exam.all, status: :ok
      end

      def show
        exam = Exam.find_by(id: params[:id])
        render json: {
          questions: exam.questions.map { |x| x.except('answer') },
          name: exam.name,
          id: exam.id
        }, status: :ok
      end

      def result
        if current_user.examinees.where(exam_id: params[:id]).blank?
          render json: GetResult.new(current_user, params[:id], params[:answers]).call, status: :ok
        else
          render json: { message: 'Forbidden' }, status: 403
        end
      end

      def skills
        render json: current_user.examinees, status: :ok
      end

      private

      def job_list_params
        params.permit(
          :time_min, :time_max,
          :min_salary,
          :max_salary, :job_title, job_provider_id: [], level: [], job_type: [],
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
