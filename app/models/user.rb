# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  role                   :integer          default(0)
#  uid                    :string           not null
#


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
  ROLES = {
    0 => 'job_seeker',
    1 => 'job_provider',
    2 => 'admin'
  }.freeze

  def nice_role
    ROLES[role]
  end
end
