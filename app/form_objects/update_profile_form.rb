# frozen_string_literal: true

class UpdateProfileForm < FormObjects::Base
  attr_reader :params, :user

  def initialize(params = {}, user)
    @params = params
    @user = user
    super()
  end

  def validate
    validate_attributes
    validate_result
  end

  def validate_attributes
    params = fetch_attributes
    @errors << error('attributes', "invalid attributes provided for user of type: #{User::ROLES[user.role]}") if params.empty?
  end

  private

  def fetch_attributes
    case user.role
    when User::ROLES.key('job_seeker')
      params.slice(:first_name, :last_name, :middle_name, :avatar,
                   :address, :phone_numbers, :education, :social_profiles)
    when User::ROLES.key('job_provider')
      params.slice(:company_name,
                   :address, :phone_numbers, :social_profiles, :avatar)
    else
      params.slice(:first_name, :last_name, :middle_name, :avatar)
    end
  end
end
