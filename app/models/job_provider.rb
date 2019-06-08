# == Schema Information
#
# Table name: job_providers
#
#  id              :bigint           not null, primary key
#  company_name    :string
#  address         :jsonb
#  phone_numbers   :jsonb
#  social_profiles :jsonb
#  user_id         :bigint
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class JobProvider < ApplicationRecord
  include Profile

  has_one_attached :avatar
  belongs_to :user
  has_many :jobs
  has_many :categories, through: :jobs
end
