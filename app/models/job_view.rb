class JobView < ApplicationRecord
  belongs_to :user
  belongs_to :job
  validates :job_id, uniqueness: { scope: :user_id }

end
