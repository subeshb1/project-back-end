# frozen_string_literal: true

class UpdateBasicInformationForm < FormObjects::Base
  attr_accessor :params, :user, :attributes

  def initialize(params = {}, user)
    @params = params.to_h
    @attributes = %i[avatar
                     address phone_numbers
                     social_accounts name description website]
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
      params[:role] = params.delete :gender
    when User::ROLES.key('job_provider')
      params[:role] = params.delete :organization_type
      params[:birth_date] = params.delete :established_date
    end
    params.slice(*attributes)
  end
end
