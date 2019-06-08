# == Schema Information
#
# Table name: applicants
#
#  id         :bigint           not null, primary key
#  status     :integer
#  user_id    :bigint
#  job_id     :bigint
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Applicant < ApplicationRecord
  belongs_to :user
  belongs_to :job
end
