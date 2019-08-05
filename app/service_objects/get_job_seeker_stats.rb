# frozen_string_literal: true

class GetJobSeekerStats
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def call
    {
      age: user.basic_information&.age,
      experience: user.work_experiences.map(&:age).sum,
      gender: user.basic_information&.nice_gender,
      program: user.educations.map(&:program),
      degree: user.educations.map(&:degree),
      skills: Exam.where(id: user.examinees.where('score >= ?', 40).map(&:exam_id)).map(&:skill_name)
    }
  end
end
