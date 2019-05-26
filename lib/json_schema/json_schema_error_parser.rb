# frozen_string_literal: true
# It parses error message given by ruby json-schema and
# manipulates to required format
class JSONSchemaErrorParser
  def self.parse(error_messages)
    api_error = { message: 'Validation Failed', errors: [] }
    error_messages.each do |error_message|
      api_error[:errors] << format_error(error_message)
    end
    api_error.to_json
  end

  def self.format_error(error_message)
    specific_error = error_message.split('in schema file:')[0]
    field = specific_error.scan(/\B'.*?'\B/).first.tr("\'", '')
    error_field = "'#{field}'"
    humanize_field = field.tr('_', '-').split('-').map(&:humanize).join(' ')
    {
      field: field.gsub!('#/', ''),
      message: "#{specific_error.split(error_field)[1].strip}".strip
    }
  end
end
