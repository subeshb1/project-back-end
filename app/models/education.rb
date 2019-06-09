# == Schema Information
#
# Table name: educations
#
#  id         :bigint           not null, primary key
#  degree     :string
#  program    :string
#  start_date :date
#  end_date   :date
#  user_id    :bigint
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Education < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :categories
end
