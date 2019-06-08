# == Schema Information
#
# Table name: jobs
#
#  id              :bigint           not null, primary key
#  uid             :string
#  description     :text
#  title           :string
#  min_salary      :float
#  max_salary      :float
#  features        :jsonb
#  open_seats      :integer          default(1)
#  job_provider_id :bigint
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Job < ApplicationRecord
  has_and_belongs_to_many :categories
  belongs_to :job_provider
  has_many_attached :images
end
