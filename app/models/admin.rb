# == Schema Information
#
# Table name: admins
#
#  id          :bigint           not null, primary key
#  first_name  :string
#  middle_name :string
#  last_name   :string
#  user_id     :bigint
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Admin < ApplicationRecord
  include Profile

  has_one_attached :avatar
  belongs_to :user
end
