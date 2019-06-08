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

  validates :role, presence: true

  has_many :social_accounts

  has_one :basic_information
  has_many :educations
  has_many :skills
  has_many :work_experiences

  has_one :company_information
  has_many :jobs
  has_many :applicants


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
end
