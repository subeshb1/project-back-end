# frozen_string_literal: true

# All authorization module for user with client role
module JobSeekerAbility
  def job_seeker(user)
    can :manage_profile, User, id: user.id
    can :update_education, User, id: user.id
  end
end
