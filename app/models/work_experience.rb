# == Schema Information
#
# Table name: work_experiences
#
#  id                :bigint           not null, primary key
#  organization_name :string
#  job_title         :string
#  level             :string
#  salary            :float
#  start_date        :datetime
#  end_date          :datetime
#  description       :text
#  user_id           :bigint
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class WorkExperience < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :categories
end
