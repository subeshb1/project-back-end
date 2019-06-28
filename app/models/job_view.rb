class JobView < ApplicationRecord
  belongs_to :user
  belongs_to :job
  validates :job_id, uniqueness: { scope: :user_id }
  after_create :update_views
  before_destroy :delete_views

  def delete_views
    job = self.job
    job.views -= 1
    job.save! if job.views >= 0
  end

  def update_views
    job = self.job
    job.views += 1
    job.save!
  end
end
