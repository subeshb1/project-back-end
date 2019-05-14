# frozen_string_literal: true

class User < ApplicationRecord
  include RandomAlphaNumeric
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  before_create :assign_unique_id
  after_create :build_profile

  JOB_SEEKER = 0
  JOB_PROVIDER = 1
  ADMIN = 2
  ROLE = {
    0 => 'job_seeker',
    1 => 'job_provider',
    2 => 'admin'
  }.freeze

  def profile
    JobSeeker.where(user_id: id).last
  end

  def build_profile
    case role
    when JOB_SEEKER
      JobSeeker.create!(user_id: id)
    when JOB_PROVIDER
      JobProvider.create!(user_id: id)
    else
      Admin.create!(user_id: id)
    end
  end
end
