# frozen_string_literal: true

class JobProviderSerializer < ActiveModel::Serializer
  attributes :company_name, :uid, :address,
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
