class EducationSerializer < ActiveModel::Serializer
  attributes :program, :degree, :categories, :start_date, :end_date

  def categories
    ActiveModel::SerializableResource.new(object.categories,  each_serializer: CategorySerializer)
  end
end
