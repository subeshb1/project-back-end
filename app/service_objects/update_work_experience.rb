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
    CreateNotification.new(user, 'hamro_job@gmail.com', user.email, "<h1>Work Experience Updated!</h1><p>Click <a href='/jobseeker/profile/work_experience'>here</a> to see the new Changes!</p><p>Thank you!</p>").call
    user.work_experiences.reload
  end

  private

  def create_work_experience(param)
    work_experience = WorkExperience.create(param.except(:categories))
    work_experience.categories << Category.where(name: param[:categories])
    work_experience
  end
end
