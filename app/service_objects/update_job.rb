# frozen_string_literal: true

class UpdateJob
  attr_reader :job, :params

  def initialize(job, params = {})
    @params = params
    @job = job
  end

  def call
    params = fetch_attributes
    job.update_attributes(params.except(:categories))
    if params[:categories]
      job.categories.destroy_all
      job.categories << Category.where(name: params[:categories])
    end
    CreateNotification.new(job.user, 'hamro_job@gmail.com', job.user.email, "<h1>Job: #{job.job_title} Updated!</h1><p>Click <a href='/jobprovider/jobs/#{job.uid}'>here</a> to see the cahnges.</p><p>Thank you!</p>").call
    job.reload
  end

  private

  def fetch_attributes
    params[:status] = Job::STATUS.key(params[:status]) if params[:status] && Job::STATUS.key(params[:status])
    params
  end
end
