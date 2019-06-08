# == Schema Information
#
# Table name: job_seekers
#
#  id              :bigint           not null, primary key
#  first_name      :string
#  middle_name     :string
#  last_name       :string
#  address         :jsonb
#  education       :jsonb
#  phone_numbers   :jsonb
#  social_profiles :jsonb
#  user_id         :bigint
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class JobSeeker < ApplicationRecord
  include Profile

  has_one_attached :avatar
  belongs_to :user
end
