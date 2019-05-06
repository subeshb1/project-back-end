# frozen_string_literal: true
# Read rack input for middleware
module RackInput
  def self.read(input)
    input_string = input.read
    input.rewind
    input_string
  end

  def self.error_response
    error_output = 'Problem parsing the body'
    [
      400,
      { 'Content-Type' => 'application/json' },
      [{ message: error_output }.to_json]
    ]
  end
end
