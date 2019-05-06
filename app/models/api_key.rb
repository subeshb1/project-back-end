# frozen_string_literal: true
# :nodoc:
class ApiKey < ActiveRecord::Base
  include RandomAlphaNumeric

  before_create -> { assign_unique_id(field: :token) }

  def self.valid_token?(token)
    ApiKey.exists?(token: token)
  end
end
