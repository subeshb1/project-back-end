# frozen_string_literal: true

class UpdateProfile
  attr_reader :params, :profile

  def initialize(params = {}, current_user)
    @profile = current_user.profile
    @params = params
  end

  def call
    profile.update_attributes(params.except(:avatar))

    profile.avatar.attach(params[:avatar]) unless params[:avatar].nil?

    profile.reload
  end
end
