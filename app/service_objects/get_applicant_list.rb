# frozen_string_literal: true

class GetApplicantList
  attr_accessor :params, :job

  def initialize(job, params)
    @params = params
    @job = job
  end

  def call
    job.applicants
       .where(status_query)
       .order(applied_date: :asc)
  end

  private

  def status_query
    { status: params[:status].map { |x| Applicant::STATUS.key(x) } } if params[:status] && !params[:status].count.zero?
  end
end
