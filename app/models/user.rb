# frozen_string_literal: true

class User < ApplicationRecord
  include RandomAlphaNumeric
  include ProfileBuilder

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  before_create :assign_unique_id
  after_create :build_profile
  after_destroy_commit :delete_profile

  validates :role, presence: true

  JOB_SEEKER = 0
  JOB_PROVIDER = 1
  ADMIN = 2
  ROLE = {
    0 => 'job_seeker',
    1 => 'job_provider',
    2 => 'admin'
  }.freeze

  def nice_role
    ROLE[role]
  end
end
