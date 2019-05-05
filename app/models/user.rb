# frozen_string_literal: true

class User < ApplicationRecord
  include RandomAlphaNumeric
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  before_create :assign_uid
  JOB_SEEKER = 0
  JOB_PROVIDER = 1
  ADMIN = 2
  ROLE = {
    0 => 'job_seeker',
    1 => 'job_provider',
    2 => 'admin'
  }.freeze
end
