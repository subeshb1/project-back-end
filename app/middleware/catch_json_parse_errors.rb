# frozen_string_literal: true
# Middleware to catch 400 errors
# and present them in json format
class CatchJsonParseErrors
  attr_reader :env_vars
  def initialize(app)
    @app = app
    @env_vars = nil
  end

  def call(env)
    @env_vars = env
    unless env_vars['CONTENT_LENGTH'].to_i.zero?
      content_type = env_vars['CONTENT_TYPE']
      if content_type && content_type.include?('application/json')
        begin
          JSON.parse(RackInput.read(env_vars['rack.input']))
        rescue JSON::ParserError
          return RackInput.error_response
        end
      end
    end

    @app.call(env_vars)
  end
end
