# frozen_string_literal: true

# All authorization module for user with admin role
module AdminAbility
  def admin(user)
    can :manage, :all
    can :get_core_roles, User
    can :create_core_user, User
  end
end
