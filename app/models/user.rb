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
  has_many :notifications

  has_one :basic_information,dependent: :destroy
  has_many :educations,dependent: :destroy
  has_many :examinees
  has_many :work_experiences,dependent: :destroy

  has_many :job_views,dependent: :destroy
  has_many :applicants,dependent: :destroy
  has_many :applications, class_name: "Applicant",dependent: :destroy
  has_many :applied_jobs, class_name: "Job", source: :job, through: :applications,dependent: :destroy
  has_many :viewed_jobs, through: :job_views, source: :job,dependent: :destroy
  has_many :skills, through: :examinees, source: :exam, dependent: :destroy

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
