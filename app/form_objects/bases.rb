# frozen_string_literal: true

module FormObjects
  # Base form object
  class Base
    attr_accessor :errors

    def initialize
      @errors = []
    end

    private

    def validate_result
      return [false, error_message] if errors.present?

      [true, nil]
    end

    def error(field, message)
      {
        field: field,
        message: message
      }
    end

    def error_message
      {
        message: 'Validation Failed',
        errors: errors
      }
    end
  end
end
