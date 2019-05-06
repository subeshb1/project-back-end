# frozen_string_literal: true
module ApiHelper
  include Rack::Test::Methods

  def app
    RailsApiTemplate::Application
  end
end
