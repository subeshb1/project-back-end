# frozen_string_literal: true

class ApproveRejectApplicant
  attr_reader :job, :param, :approve

  def initialize(job, param, approve = false)
    @job = job
    @param = param
    @approve = approve
  end

  def call
    job.applicants.where(id: param[:applicant_id])
       .update_all(status: Applicant::STATUS
        .key(approve ? 'approved' : 'rejected'))
  end
end
