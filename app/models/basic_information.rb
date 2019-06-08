# frozen_string_literal: true

# == Schema Information
#
# Table name: basic_informations
#
#  id              :bigint           not null, primary key
#  name            :string
#  birth_date      :date
#  phone_numbers   :jsonb
#  social_accounts :jsonb
#  type            :integer
#  description     :text
#  website         :string
#  user_id         :bigint
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class BasicInformation < ApplicationRecord
  has_one_attached :image
  belongs_to :user
  has_and_belongs_to_many :categories

  GENDER = {
    0 => 'male',
    1 => 'female',
    2 => 'other'
  }.freeze

  ORGANIZATION_TYPE = {
    0 => 'small',
    1 => 'medium',
    2 => 'large'
  }.freeze

  def established_date
    birth_date
  end

  def age
    this_year = Date.today.year
    year = this_year - birth_date.year
    year -= 1 if
      (birth_date.month > this_year.month) ||
      ((birth_date.month >= this_year.month) && (birth_date.day > this_year.day))
    year
  end

  def nice_gender
    GENDER[role]
  end

  def gender
    role
  end

  def nice_organization_type
    GENDER[role]
  end

  def organization_type
    role
  end
end
