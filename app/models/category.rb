class Category < ApplicationRecord
  has_and_belongs_to_many :jobs
  has_one_attached :image
end
