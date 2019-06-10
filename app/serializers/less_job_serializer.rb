# frozen_string_literal: true

class LessJobSerializer < ActiveModel::Serializer
  attributes :job_title, :open_seats, :level, :min_salary,
             :max_salary,
             :job_type,
             :categories,
             :active_storage_blobs

  def categories
    ActiveModel::SerializableResource.new(object.categories, each_serializer: CategorySerializer)
  end
end
