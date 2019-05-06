# frozen_string_literal: true
# :nodoc:
class JSONSchemaValidator
  def self.validate(schema_path, params)
    errors = JSON::Validator.fully_validate(schema_path, params.to_json)
    if errors.present?
      error_messages = JSONSchemaErrorParser.parse(errors)
      raise JSON::Schema::CustomFormatError, error_messages
    end
  end
end
