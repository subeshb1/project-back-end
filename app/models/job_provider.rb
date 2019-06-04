class JobProvider < ApplicationRecord
  include Profile

  has_one_attached :avatar
  belongs_to :user
  has_many :jobs
end
