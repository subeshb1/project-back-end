# frozen_string_literal: true

# All authorization module for user with client role
module ClientAbility
  def job_seeker(user)
    can :manage_profile, User, id: user.id
  end
end
