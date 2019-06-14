# frozen_string_literal: true

class BasicInformationSerializer < ActiveModel::Serializer
  attributes :name, :uid, :address, :birth_date, :established_date,
             :gender, :organization_type, :website, :description,
             :phone_numbers, :social_accounts, :avatar, :email, :categories

  def uid
    object.user.uid
  end

  def gender
    object.nice_gender
  end

  def birth_date
    object.birth_date unless object.user.role == User::ROLES.key('job_provider')
  end

  def organization_type
    object.nice_organization_type
  end

  def email
    object.user.email
  end

  def avatar
    return nil unless object.avatar.attached?

    ENV['URL'] + Rails.application.routes.url_helpers.rails_blob_path(object.avatar,
                                                                      only_path: true)
  end

  def categories
    object.categories&.map(&:name)
  end
end
