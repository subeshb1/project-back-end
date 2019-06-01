class UserSerializer < ActiveModel::Serializer
  attributes :uid, :email, :role

  def role
    User::ROLES[object.role]
  end
end
