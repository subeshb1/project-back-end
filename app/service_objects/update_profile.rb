# frozen_string_literal: true

class UpdateProfile
  attr_reader :params, :profile, :user

  def initialize(params = {}, current_user)
    @profile = current_user.profile
    @params = params
    @user = current_user
  end

  def call
    params = fetch_attributes
    profile.update_attributes(params.except(:avatar))
    profile.avatar.attach(params[:avatar]) unless params[:avatar].nil?
    profile.reload
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
