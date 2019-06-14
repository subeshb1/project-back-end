# frozen_string_literal: true

class UpdateEducation
  attr_reader :params, :user

  def initialize(current_user, params = {})
    @params = params
    @user = current_user
  end

  def call
    user.educations.destroy_all

    user.educations << params[:educations].each_with_object([]) do |param, educations|
      educations << create_education(param)
    end
    user.educations.reload
  end

  private

  def create_education(param)
    education = Education.create(param.except(:categories))
    education.categories << Category.where(name: param[:categories])
    education
  end
end
