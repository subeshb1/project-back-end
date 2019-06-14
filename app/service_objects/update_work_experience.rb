# frozen_string_literal: true

class UpdateWorkExperience
  attr_reader :params, :user

  def initialize(current_user, params = {})
    @params = params
    @user = current_user
  end

  def call
    user.work_experiences.destroy_all

    user.work_experiences << params[:work_experiences].each_with_object([]) do |param, work_experiences|
      work_experiences << create_work_experience(param)
    end
    user.work_experiences.reload
  end

  private

  def create_work_experience(param)
    work_experience = WorkExperience.create(param.except(:categories))
    work_experience.categories << Category.where(name: param[:categories])
    work_experience
  end
end
