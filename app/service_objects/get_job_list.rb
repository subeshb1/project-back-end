# frozen_string_literal: true

class GetJobList
  attr_accessor :params, :job_provider

  def initialize(params, job_provider = false)
    @params = params
    @job_provider = job_provider
  end

  def call
    jobs = Job.includes(:categories)
              .where('application_deadline >= ? ', @job_provider ? Date.new(1990) : Date.today)
              .where(company_query)
              .where(categories_query)
              .where(application_deadline_query)
              .where(job_title_query)
              .where(salary_query)
              .where(type_level_query)

    return jobs.order(order_by) if @job_provider

    jobs
  end

  private

  def job_title_query
    return unless params[:job_title]

    ['lower(job_title) like ?', "%#{params.delete(:job_title).downcase}%"]
  end

  def application_deadline_query
    time_min = params.delete(:time_min)
    time_max = params.delete(:time_max)

    if time_min && time_max
      "application_deadline <= '#{time_max}' AND application_deadline >= '#{time_min}'"
    elsif time_min
      "application_deadline >= '#{time_min}'"
    elsif time_max
      "application_deadline <= '#{time_max}'"
    end
  end

  def categories_query
    { 'categories.name': params.delete(:categories) } if params[:categories] && !params[:categories].count.zero?
  end

  def salary_query
    min_salary = params.delete(:min_salary)
    max_salary = params.delete(:max_salary)

    if min_salary && max_salary
      "min_salary < '#{max_salary}' AND max_salary > '#{min_salary}'"
    elsif min_salary
      "max_salary > '#{min_salary}'"
    elsif max_salary
      "min_salary < '#{max_salary}'"
    end
  end

  def type_level_query
    query = {}
    query[:level] = params.delete(:level) if params[:level] && !params[:level].count.zero?
    query[:job_type] = params.delete(:job_type) if params[:job_type] && !params[:job_type].count.zero?
    query
  end

  def company_query
    { user_id: User.where(uid: params.delete(:job_provider_id)) } if params[:job_provider_id] && !params[:job_provider_id].count.zero?
  end

  def order_by
    return { created_at: :desc } unless params[:order] && params[:order_by]

    order = {}
    order[params[:order_by]] = params[:order]
    order
  end
end
