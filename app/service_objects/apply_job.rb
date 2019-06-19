# frozen_string_literal: true

class ApplyJob
  attr_reader :user, :job

  def initialize(user,job)
    @user = user
    @job = job
  end

  def call
    user.viewed_jobs << job unless user.viewed_jobs.include?(job)
    user.applied_jobs << job unless user.applied_jobs.include?(job)
  end
end
