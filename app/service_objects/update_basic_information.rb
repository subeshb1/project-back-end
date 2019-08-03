# frozen_string_literal: true

class UpdateBasicInformation
  attr_reader :params, :basic_information, :user, :attributes

  def initialize(params = {}, current_user)
    @basic_information = BasicInformation.find_or_create_by(user_id: current_user.id)
    @params = params.to_h.with_indifferent_access
    @attributes = %i[avatar birth_date
                     address phone_numbers education role
                     social_accounts name description website categories]
    @user = current_user
  end

  def call
    params = fetch_attributes
    basic_information.update_attributes(params.except(:avatar, :categories))
    basic_information.avatar.attach(params[:avatar]) unless params[:avatar].nil?
    if params[:categories]
      basic_information.categories.destroy_all
      basic_information.categories << Category.where(name: params[:categories])
    end
    CreateNotification.new(user, 'hamro_job@gmail.com', user.email, "<h1>Basic Information Updated!</h1><p>Click <a href='/#{User::ROLES[user.role].gsub('_', '')}/profile/basic_info'>here</a> to see the new Changes!</p><p>Thank you!</p>").call
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
