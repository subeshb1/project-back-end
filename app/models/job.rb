class Job < ApplicationRecord
  has_and_belongs_to_many :categories
  belongs_to :job_provider
  has_many_attached :images
end
