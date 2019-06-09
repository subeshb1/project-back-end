# frozen_string_literal: true

class GetProfileStatus
  attr_accessor :user

  def initialize(user)
    @user = user
  end

  def call
    status = {}
    status[:basic_info] = status[:complete] = complete_basic_info?
    unless user.job_provider?
      status[:complete] &&= complete_education? && complete_work_experience?
      status[:education] = complete_education?
      status[:work_experience] = complete_work_experience?
    end
    status
  end

  private

  def complete_basic_info?
    user.basic_information&.complete? || false
  end

  def complete_work_experience?
    user.work_experiences.count.positive?
  end

  def complete_education?
    user.educations.count.positive?
  end
end
