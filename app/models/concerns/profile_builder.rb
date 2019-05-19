# frozen_string_literal: true

module ProfileBuilder
  extend ActiveSupport::Concern

  included do
    def profile
      case role
      when User::JOB_SEEKER
        JobSeeker.find_user id
      when User::JOB_PROVIDER
        JobProvider.find_user id
      else
        Admin.find_user id
      end
    end

    def build_profile
      case role
      when User::JOB_SEEKER
        JobSeeker.create!(user_id: id)
      when User::JOB_PROVIDER
        JobProvider.create!(user_id: id)
      else
        Admin.create!(user_id: id)
      end
    end

    def delete_profile
      profile.destroy
    end
  end
end
