# frozen_string_literal: true

class ProfileSerializer < ActiveModel::Serializer
  attributes :work_experiences, :basic_info, :educations, :user, :skills

  def work_experiences
    ActiveModel::SerializableResource.new(object[:work_experiences], each_serializer: WorkExperienceSerializer)
  end

  def educations
    ActiveModel::SerializableResource.new(object[:educations], each_serializer: EducationSerializer)
  end

  def basic_info
    ActiveModel::SerializableResource.new(object[:basic_info], each_serializer: BasicInformationSerializer)
  end

  def user
    ActiveModel::SerializableResource.new(object[:user], each_serializer: UserSerializer)
  end

  def skills
    object[:skills]
  end
end
