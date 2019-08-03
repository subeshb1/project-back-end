# frozen_string_literal: true

class RecommendSerializer < ActiveModel::Serializer
  attributes :recommended, :history, :categories, :top_jobs, :latest_jobs

  def recommended
    ActiveModel::SerializableResource.new(object[:recommended], each_serializer: LessJobSerializer)
  end

  def history
    ActiveModel::SerializableResource.new(object[:history], each_serializer: LessJobSerializer)
  end

  def latest_jobs
    ActiveModel::SerializableResource.new(object[:latest_jobs], each_serializer: LessJobSerializer)
  end

  def categories
    ActiveModel::SerializableResource.new(object[:categories], each_serializer: LessJobSerializer)
  end

  def top_jobs
    ActiveModel::SerializableResource.new(object[:top_jobs], each_serializer: LessJobSerializer)
  end
end
