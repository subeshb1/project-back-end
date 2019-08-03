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
    param[:applicant_id].each do |id|
      user = Applicant.find_by(id: id).user
      CreateNotification.new(user, job.user.email, user.email, message).call
    end
  end

  def message
    if approve
      return %(<h1>Application Approved!</h1>
        <p>Your application for the job
          <a href='/job/#{job.uid}'>#{job.job_title}</a>
          by
          <a href='/profile/#{job.user.uid}'>#{job.user.basic_information&.name}</a> has been appoved!
        </p>
        <p>The team from #{job.user.basic_information&.name} will contact you shortly.</p>
        <p>Thank you!</p>
      )
    end

    %(<h1>Application Rejected!</h1>
      <p>Your application for the job
      <a href='/job/#{job.uid}'>#{job.job_title}</a>
      by
      <a href='/profile/#{job.user.uid}'>#{job.user.basic_information&.name}</a> has been rejected!</p>
      <p>Sorry!</p>
    )
  end
end
