# frozen_string_literal: true

class CheckEligibilityForm < FormObjects::Base
  attr_reader :job_specifications, :user_stats, :user, :job

  def initialize(user, job)
    @user = user
    @job = job
    @user_stats = GetJobSeekerStats.new(user).call
    @job_specifications = job[:job_specifications].with_indifferent_access
    super()
  end

  def validate
    validate_age
    validate_gender
    validate_experience
    validate_program
    validate_degree
    validate_previous_apply
    validate_skills
    validate_result
  end

  private

  def validate_previous_apply
    return unless user.applied_jobs.include? job

    @errors << error('job',
                     'Already applied!')
  end

  def validate_age
    return unless job_specifications[:age][:require]

    max = job_specifications[:age][:max]
    min = job_specifications[:age][:min]
    age = user_stats[:age]
    return if age >= min && age <= max

    @errors << error('age',
                     "You don't fit in to the required age group")
  end

  def validate_experience
    return unless job_specifications[:experience][:require]

    experience = user_stats[:experience]
    job_experience = job_specifications[:experience][:value][0].to_i
    return if experience >= job_experience

    @errors << error('experience',
                     'Not enough Job Expereience!')
  end

  def validate_program
    return unless job_specifications[:program][:require]

    program = user_stats[:program]
    job_program = job_specifications[:program][:value]
    return unless (program & job_program).empty?

    @errors << error('program',
                     'You need qualification in specified programs!')
  end

  def validate_degree
    return unless job_specifications[:degree][:require]

    degree = user_stats[:degree]
    job_degree = job_specifications[:degree][:value]
    return unless (degree & job_degree).empty?

    @errors << error('degree',
                     'You need qualification in specified degrees!')
  end

  def validate_gender
    return unless job_specifications[:gender][:require]

    gender = [user_stats[:gender]]
    job_gender = job_specifications[:gender][:value]
    return unless (gender & job_gender).empty?

    @errors << error('gender',
                     'Only specified genders can apply!')
  end

  def validate_skills
    return unless job_specifications[:skills][:require]

    skills = user_stats[:skill]
    job_skill = job_specifications[:skill][:value]
    return unless (skills & job_skill).empty?

    @errors << error('skills',
                     'You can only apply if you have the listed skills!')
  end
end
