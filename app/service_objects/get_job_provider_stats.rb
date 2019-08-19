# frozen_string_literal: true

class GetJobProviderStats
  attr_reader :user, :jobs, :params

  def initialize(user, params = {})
    @user = user
    @jobs = user.jobs
    @params = params
  end

  def call
    {
      job_categories: job_categories,
      applicant_status: applicant_status,
      total_applicants: total_job_applicants,
      total_views: total_job_views,
      total_jobs: total_jobs,
      total_open_jobs: total_open_jobs,
      daily_views: daily_views,
      daily_applicants: daily_applicants

    }
  end

  def time_query(param = 'application_deadline')
    time_min = @params[:time_min]
    time_max = @params[:time_max]

    if time_min && time_max
      "#{param} <= '#{time_max}' AND #{param} >= '#{time_min}'"
    elsif time_min
      "#{param} >= '#{time_min}'"
    elsif time_max
      "#{param} <= '#{time_max}'"
    end
  end

  def job_categories
    jobs.where(time_query('jobs.created_at')).joins('LEFT OUTER JOIN "categories_jobs" ON "categories_jobs"."job_id" = "jobs"."id" LEFT OUTER  JOIN "categories" ON "categories"."id" = "categories_jobs"."category_id"').group('categories.name').count
  end

  def total_jobs
    jobs.where(time_query('jobs.created_at')).count
  end

  def total_open_jobs
    jobs.where(time_query('jobs.created_at')).where('application_deadline >= ? ', Date.today).count
  end

  def total_job_views
    JobView
      .where(time_query('job_views.created_at'))
      .where(job_id: jobs.pluck(:id))
      .count
  end

  def total_job_applicants
    Applicant
      .where(time_query('applicants.created_at'))
      .where(job_id: jobs.pluck(:id))
      .count
  end

  def applicant_status
    status = Applicant .where(job_id: jobs.pluck(:id)) .where(time_query('applicants.created_at')).group(:status) .count
    {
      'pending' => status[0],
      'interview' => status[1],
      'hired' => status[2],
      'rejected' => status[3]
    }
  end

  def daily_views
    JobView
      .where(job_id: jobs.pluck(:id))
      .where(time_query('created_at'))
      .group('date(created_at)')
      .count
  end

  def daily_applicants
    Applicant
      .where(time_query('created_at'))
      .where(job_id: jobs.pluck(:id))
      .group('date(created_at)')
      .count
  end
end
