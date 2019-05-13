# frozen_string_literal: true

class CreateUserForm < FormObjects::Base
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.freeze
  attr_reader :params

  def initialize(params = {})
    @params = params
    super()
  end

  def validate
    validate_email
    validate_password
    validate_result
  end

  private

  def validate_email
    @errors << error('email', 'must be a valid email pattern') unless
      params[:email] =~ VALID_EMAIL_REGEX
  end

  def validate_password
    @errors << error('password', 'don\'t match') unless
      params[:password] == params[:confirm_password]
  end
end
