# frozen_string_literal: true

class JobSerializer < ActiveModel::Serializer
  attributes :job_title, :open_seats, :level, :min_salary,
             :max_salary,
             :description, :job_type, :application_deadline,
             :categories,
             :questions,
             :job_specifications, :uid

  def categories
    ActiveModel::SerializableResource.new(object.categories, each_serializer: CategorySerializer)
  end
end
