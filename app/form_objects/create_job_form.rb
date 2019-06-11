# frozen_string_literal: true

class CreateJobForm < FormObjects::Base
  attr_reader :params, :user

  def initialize(user, params = {})
    @params = params
    @user = user
    super()
  end

  def validate
    validate_application_deadline
    validate_salary
    validate_uniqueness
    validate_result
  end

  private

  def validate_uniqueness
    @errors << error('duplicate job', 'job with exact same information exists') if
    Job.where(params.except(:questions, :categories).merge(user_id: user.id)).count.positive?
  end

  def validate_application_deadline
    @errors << error('application_deadline', 'must be in the future') unless
    params[:application_deadline].to_date + 1 > Date.today
  end

  def validate_open_seats
    @errors << error('open_seats', 'should be greater than zero') unless
    params[:open_seats] < 1
  end

  def validate_salary
    @errors << error('min_salary', 'must be a greater than max salary') unless
    params[:min_salary].to_f <= params[:max_salary].to_f
  end
end
