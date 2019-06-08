# frozen_string_literal: true

class UpdateBasicInformation
  attr_reader :params, :basic_information, :user, :attributes

  def initialize(params = {}, current_user)
    @basic_information = BasicInformation.find_or_create_by(user_id: current_user.id)
    @params = params.to_h
    @attributes = %i[avatar birth_date
                     address phone_numbers education role
                     social_accounts name description website]
    @user = current_user
  end

  def call
    params = fetch_attributes
    basic_information.update_attributes(params.except(:avatar))
    basic_information.avatar.attach(params[:avatar]) unless params[:avatar].nil?
    basic_information.reload
  end

  private

  def fetch_attributes
    case user.role
    when User::ROLES.key('job_seeker')
      params[:role] = BasicInformation::GENDER.key params.delete :gender if params.key? :gender
    when User::ROLES.key('job_provider')
      params[:role] = BasicInformation::ORGANIZATION_TYPE.key params.delete :organization_type if params.key? :organization_type
      params[:birth_date] = params.delete :established_date if params.key? :established_date
    end

    params.slice(*attributes)
  end
end
