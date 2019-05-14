class UserSerializer < ActiveModel::Serializer
  attributes :uid, :email, :role
  
  def role
    User::ROLE[object.role]
  end
end
