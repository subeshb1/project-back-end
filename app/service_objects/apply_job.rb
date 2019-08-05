# frozen_string_literal: true

class ApplyJob
  attr_reader :user, :job

  def initialize(user, job)
    @user = user
    @job = job
  end

  def call
    user.viewed_jobs << job unless user.viewed_jobs.include?(job)
    user.applied_jobs << job unless user.applied_jobs.include?(job)
    CreateNotification.new(user, job.user.email, user.email, message).call
  end

  def message
    %(<h1>Application Submitted!</h1>
      <p>Your application for the job <a href='/job/#{job.uid}'>#{job.job_title}</a>
      by
      <a href='/profile/#{job.user.uid}'>#{job.user.basic_information&.name}</a> has been submitted!</p>
      <p>Your application is now under review. You will be notified after the results have been announced.</p>
      <p>Thank you!</p>
    )
  end
end
