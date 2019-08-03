# frozen_string_literal: true

class CreateJob
  attr_reader :params, :user
  def initialize(current_user, params = {})
    @params = params
    @user = current_user
  end

  def call
    job = Job.new(user_id: user.id)
    job.update_attributes(params.except(:categories))
    job.categories << Category.where(name: params[:categories])
    job.save!
    CreateNotification.new(user, 'hamro_job@gmail.com', user.email, "<h1>Job: #{job.job_title} Created!</h1><p>You'll soon be seeing applicants for this Job!</p><p>Click <a href='/jobprovider/jobs/#{job.uid}'>here</a> to edit or view job progress.</p><p>Thank you!</p>").call
    job.reload
  end
end
