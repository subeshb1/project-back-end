# frozen_string_literal: true

class UpdateProfileForm < FormObjects::Base
  attr_reader :params

  def initialize(params = {})
    @params = params
    super()
  end

  def validate
    validate_email
    validate_password
    validate_no_user
    validate_result
  end

  private

  
end
