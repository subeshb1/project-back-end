# frozen_string_literal: true

class Applicant < ApplicationRecord
  STATUS = {
    0 => 'pending',
    1 => 'approved',
    2 => 'rejected'
  }.freeze

  belongs_to :user
  belongs_to :job
  before_save :default_values
  def default_values
    self.status ||= 0
    self.applied_date ||= DateTime.now
  end

  def nice_status
    STATUS[status]
  end
end
