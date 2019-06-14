class EducationSerializer < ActiveModel::Serializer
  attributes :program, :degree, :categories, :start_date, :end_date

  def categories
    object.categories&.map(&:name)
  end
end
