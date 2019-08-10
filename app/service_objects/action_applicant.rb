# frozen_string_literal: true

class ActionApplicant
  attr_reader :job, :param
  def initialize(job, param)
    @job = job
    @param = param
  end

  def call
    job.applicants.where(id: param[:applicant_id])
       .update_all(status: Applicant::STATUS
        .key(param[:action_performed]))
    param[:applicant_id].each do |id|
      user = Applicant.find_by(id: id).user
      CreateNotification.new(user, job.user.email, user.email, message).call
    end
  end

  def message
    case param[:action_performed]
    when 'interview'
      %(<h1>Application Approved!</h1>
        <p>Your application for the job
          <a href='/job/#{job.uid}'>#{job.job_title}</a>
          by
          <a href='/profile/#{job.user.uid}'>#{job.user.basic_information&.name}</a> has been appoved!
        </p>
        <p>The team from #{job.user.basic_information&.name} will contact you shortly.</p>
        <p>Thank you!</p>
      )
    when 'hired'

    when 'rejected'
      %(<h1>Application Rejected!</h1>
        <p>Your application for the job
        <a href='/job/#{job.uid}'>#{job.job_title}</a>
        by
        <a href='/profile/#{job.user.uid}'>#{job.user.basic_information&.name}</a> has been rejected!</p>
        <p>Sorry!</p>
      )
    else
      %(<h1>Application Rejected!</h1>
        <p>Your application for the job
        <a href='/job/#{job.uid}'>#{job.job_title}</a>
        by
        <a href='/profile/#{job.user.uid}'>#{job.user.basic_information&.name}</a> has been rejected!</p>
        <p>Sorry!</p>
      )
    end
  end
end
