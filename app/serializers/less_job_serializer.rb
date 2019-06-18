# frozen_string_literal: true

class LessJobSerializer < ActiveModel::Serializer
  attributes :job_title, :open_seats, :level, :min_salary,
             :max_salary,
             :job_type,
             :status,
             :uid,
             :application_deadline
  def categories
    object.categories&.map(&:name)
  end
  
  def status
    object.nice_status
  end
end
