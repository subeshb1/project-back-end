# == Schema Information
#
# Table name: jobs
#
#  id          :bigint           not null, primary key
#  uid         :string
#  description :text
#  title       :string
#  min_salary  :float
#  max_salary  :float
#  features    :jsonb
#  open_seats  :integer          default(1)
#  level       :integer
#  type        :integer
#  user_id     :bigint
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Job < ApplicationRecord
  include RandomAlphaNumeric
  ACTIVE = 0
  PROCESSING = 1
  COMPLETED = 2
  STATUS = {
    0 => 'active',
    1 => 'processing',
    2 => 'completed'
  }

  before_create :assign_unique_id

  has_and_belongs_to_many :categories
  belongs_to :job_provider
  has_many_attached :images

  has_many :job_views
  has_many :applicants
  has_many :viewers, class_name: "User", through: :job_views

  def nice_status
    STATUS[status]
  end
end

# class CreateApplicants < ActiveRecord::Migration[5.2]
#   def change
#     create_table :applicants do |t|
#       t.integer :status, limit: 1
#       t.belongs_to :user, foreign_key: true
#       t.belongs_to :job, foreign_key: true
#       t.timestamps
#     end
#   end
# end
