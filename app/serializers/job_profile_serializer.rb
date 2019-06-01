# frozen_string_literal: true

class JobProviderSerializer < ActiveModel::Serializer
  attributes :first_name, :last_name, :uid, :address, :education,
             :phone_numbers, :social_profiles, :avatar

  def uid
    object.user.uid
  end

  def avatar
    return nil unless object.avatar.attached?

    Rails.application.routes.url_helpers.rails_blob_path(user.avatar, 
                                                         only_path: true)
  end
end
