# frozen_string_literal: true

module Rack
  class MockResponse
    def parsed_body
      JSON.parse(body)
    end
  end
end
