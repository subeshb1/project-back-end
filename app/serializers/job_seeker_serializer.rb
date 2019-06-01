# frozen_string_literal: true

class JobSeekerSerializer < ActiveModel::Serializer
  attributes :first_name, :last_name, :uid, :address, :education,
             :phone_numbers, :social_profiles, :avatar, :email

  def uid
    object.user.uid
  end

  def email
    object.user.email
  end

  def avatar
    return nil unless object.avatar.attached?

    ENV['URL'] + Rails.application.routes.url_helpers.rails_blob_path(object.avatar,
                                                                      only_path: true)
  end
end
