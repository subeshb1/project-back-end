# frozen_string_literal: true

class GetProfile
  attr_accessor :user

  def initialize(user)
    @user = user
  end

  def call
    {
      basic_info: user.basic_information,
      educations: user.educations,
      work_experiences: user.work_experiences
    }
  end
end
