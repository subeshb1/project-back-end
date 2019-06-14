# == Schema Information
#
# Table name: categories
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Category < ApplicationRecord
  has_and_belongs_to_many :jobs
  has_and_belongs_to_many :basic_informations, join_table: "categories_basic_informations"
  has_and_belongs_to_many :educations
  has_and_belongs_to_many :work_experiences
  has_one_attached :image
end
