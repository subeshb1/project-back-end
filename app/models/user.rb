# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                 :bigint           not null, primary key
#  email              :string           default(""), not null
#  encrypted_password :string           default(""), not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  role               :integer          default(0)
#  uid                :string           not null
#

class User < ApplicationRecord
  include RandomAlphaNumeric

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  before_create :assign_unique_id
  after_create :create_basic_information

  validates :role, presence: true

  has_many :social_accounts

  has_one :basic_information
  has_many :educations
  has_many :skills
  has_many :work_experiences

  has_many :job_views
  has_many :applicants
  has_many :applications, class_name: "Applicant"
  has_many :applied_jobs, class_name: "Job", source: :job, through: :applications
  has_many :viewed_jobs, through: :job_views, source: :job

  has_many :jobs
  has_many :applicants

  scope :job_seeker, -> { where(role: JOB_SEEKER) }
  scope :job_provider, -> { where(role: JOB_PROVIDER) }
  scope :admin, -> { where(role: ADMIN) }

  JOB_SEEKER = 0
  JOB_PROVIDER = 1
  ADMIN = 2
  ROLES = {
    0 => 'job_seeker',
    1 => 'job_provider',
    2 => 'admin'
  }.freeze

  def nice_role
    ROLES[role]
  end

  def job_seeker?
    role == JOB_SEEKER
  end

  def job_provider?
    role == JOB_PROVIDER
  end

  def admin?
    role == ADMIN
  end
end
