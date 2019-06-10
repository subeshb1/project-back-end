# frozen_string_literal: true

# All authorization module for user with core role
module JobProviderAbility
  def job_provider(user)
    can :create_job, User
  end
end
