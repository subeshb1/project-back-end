# frozen_string_literal: true

class LessJobSerializer < ActiveModel::Serializer
  attributes :job_title, :open_seats, :level, :min_salary,
             :max_salary,
             :job_type,
             :status,
             :uid,
             :application_deadline,
             :created_at,
             :company_name,
             :company_avatar

  def categories
    object.categories&.map(&:name)
  end
  
  def status
    object.nice_status
  end

  def company_name
    object.user.basic_information&.name || ''
  end

  def company_avatar
    return nil unless object.user.basic_information.avatar.attached?

    ENV['URL'] + Rails.application.routes.url_helpers.rails_blob_path(object.user.basic_information.avatar,
                                                                      only_path: true)
  end
end
