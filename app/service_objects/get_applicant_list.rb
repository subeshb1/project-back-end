# frozen_string_literal: true

class GetApplicantList
  attr_accessor :params, :job

  def initialize(job, params)
    @params = params
    @job = job
  end

  def call
    user_ids = job.applicants
                  .where(status_query)
                  .where(from_to_query)
                  .pluck(:user_id)
    user_ids = BasicInformation
               .where(user_id: user_ids)
               .where(age_query)
               .where(name_query)
               .where(gender_query)
               .pluck(:user_id)
    if params[:degree] || params[:program]
      user_ids = Education
                .where(user_id: user_ids)
                .where(degree_query)
                .where(program_query)
                .pluck(:user_id)
    end
    if params[:skills]
      user_ids = Examinee.where(user_id: user_ids, exam_id: Exam.where(skill_name: params[:skills]))
                         .where('score >= ?', 40)
                         .pluck(:user_id)
    end
    if params[:experience]
      user_ids = User.where(id: user_ids)
                     .select { |x| x.work_experiences.map(&:age).sum >= params[:experience].to_i }
                     .pluck(:id)
    end
    Applicant.where(job_id: job.id, user_id: user_ids).order(order_by)
  end

  private

  def name_query
    return unless params[:name]

    ['lower(name) like ?', "%#{params.delete(:name).downcase}%"]
  end

  def degree_query
    { degree: params[:degree] } if params[:degree] && !params[:degree].count.zero?
  end

  def program_query
    { program: params[:program] } if params[:program] && !params[:program].count.zero?
  end

  def status_query
    { status: params[:status].map { |x| Applicant::STATUS.key(x) } } if params[:status] && !params[:status].count.zero?
  end

  def gender_query
    { role: params[:gender].map { |x| BasicInformation::GENDER.key(x) } } if params[:gender] && !params[:gender].count.zero?
  end

  def age_query
    return unless params[:max_age] || params[:min_age]

    age_max = (Date.today - params.delete(:max_age).to_i.years) if params[:max_age]
    age_min = (Date.today - params.delete(:min_age).to_i.years) if params[:min_age]

    if age_min && age_max
      "birth_date >= '#{age_max}' AND birth_date <= '#{age_min}'"
    elsif age_min
      "birth_date <= '#{age_min}'"
    elsif age_max
      "birth_date >= '#{age_max}'"
    end
  end

  def from_to_query
    time_min = params.delete(:start_date).to_datetime.beginning_of_day if params[:start_date]
    time_max = params.delete(:end_date)

    if time_min && time_max
      "applied_date <= '#{time_max}' AND applied_date >= '#{time_min}'"
    elsif time_min
      "applied_date >= '#{time_min}'"
    elsif time_max
      "applied_date <= '#{time_max}'"
    end
  end

  def order_by
    return { applied_date: :desc } unless params[:order] && params[:order_by]

    order = {}
    order[params[:order_by]] = params[:order]
    order
  end
end
