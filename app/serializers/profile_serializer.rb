class ProfileSerializer < ActiveModel::Serializer
  attributes :first_name, :last_name, :uid, :address, :education,
             :phone_numbers, :social_profiles, :avatar

  def uid
    object.user.uid
  end

  def avatar
  end

  def avatar
  end

  def avatar
  end

  def avatar
  end
end
