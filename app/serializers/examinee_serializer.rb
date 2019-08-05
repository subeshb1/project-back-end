class ExamineeSerializer < ActiveModel::Serializer
  attributes :score, :skill_name, :user_id, :id

  def skill_name
    object.exam.skill_name
  end

  def user_id
    object.user.uid
  end
end
