# frozen_string_literal: true

class ApplicantSerializer < ActiveModel::Serializer
  attributes :name, :uid, :status, :id, :applied_date, :job, :id

  def uid
    object.user.uid
  end

  def name
    object.user.basic_information.name
  end

  def job
    LessJobSerializer.new(object.job)
  end

  def status
    object.nice_status
  end
end
