class JobSeeker < ApplicationRecord
  include Profile
  
  has_one_attached :avatar
  belongs_to :user
end
